<?php

namespace App\Http\Controllers;

use App\Models\Connection;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

use function PHPUnit\Framework\isEmpty;

class ConnectionsController extends Controller
{
    // query the user's connection with status accepted or disconnected
    public function display_history (){
        $user = Auth::user();
        
        // records where status is [accepted or disconnected] and requester or responder are the current user
        $connections = Connection::whereIn('status', ['accepted', 'disconnected']) 
                                -> with('requester_user', 'responder_user') 
                                -> where (function ($query) use ($user)  {
                                $query -> where('requester', $user->id)-> orWhere('responder', $user->id);}) 
                                -> get();
                                
            if (isset($connections[0])) {
                $response_array = [];
    
                foreach ($connections as $connection){
                    // if user is the requester
                    if ($connection['requester'] == $user -> id) {
                        // partner is responder so add responder
                        $response_array[] = [
                            "id" => $connection -> id,
                            "partner_name" => $connection['responder_user']['username'],
                            "partner_email" => $connection['responder_user']['email'],
                            "user_name" => $connection['requester_user']['username'],
                            "status" => $connection->status
                        ]; 
    
                        // if user is the responder
                    } elseif ($connection['responder'] == $user -> id) {
                        // partner is requester so add requester
                        $response_array[] = [
                            "id" => $connection -> id,
                            "partner_name" => $connection['requester_user']['username'],
                            "partner_email" => $connection['requester_user']['email'],
                            "user_name" => $connection['responder_user']['username'],
                            "status" => $connection->status
                        ];
                    }
                }
    
                return response()->json([
                    "status" => 'success',
                    "connections" => $response_array
                ]);
            } else {
                return response()->json([
                    "status" => "failed",
                    "message" => "You don't have any past or current connections"
                ]);
            } 

    }

    // sends a request only when users don't have a connection or if their previous connections are [rejected, disconnected]
    // if status is [pending, connected] request will not be sent
    public function send_request(Request $request){

        $request -> validate([
            "email" => "required|max:100"
        ]);

        $email_exists = User::where('email', $request->email)->get();

        if (isset($email_exists[0])){
            // if status is rejected or disconnected I want to be able to send again
            $user = Auth::user();
            $requester_id = $user->id;
            $responder_id = $email_exists[0]->id; 

            $connection_exists_first_way = Connection::whereIn('status', ['pending', 'accepted']) -> where(["requester"=>$requester_id , "responder"=>$responder_id]) ->get();
            
            $connection_exists_second_way = Connection::whereIn('status', ['pending', 'accepted']) -> where(["requester"=>$responder_id , "responder"=>$requester_id]) ->get();

            if (count($connection_exists_first_way) > 0 || count($connection_exists_second_way) > 0 ) {
                return response()->json([
                    "status" => "failed",
                    "message" =>  "Connection already exists",
                ], 405);
            } else {
                
                $connection = Connection::create([
                    "requester" => $requester_id,
                    "responder" => $responder_id,
                ]);

                return response()->json([
                    "status" => "success",
                    "message" =>  "Request has been sent. Good Luck!",
                    "connection" => $connection
                ]);
            }
        } else {
            return response()->json([
                "status" => "failed",
                "message" => "Request failed. User doesn't exist"
            ], 403);
        }
    }


    // receiving end of a request
    // query connections where user is the responder and status is pending 
    public function display_requests() {

        $user = Auth::user();
        $incoming_requests = Connection::where(['status'=>'pending', 'responder'=>$user->id])-> get();
        if ($user -> connection_status == "true"){

            return response() -> json([
                "status" => "rejected",
                "message" => "Already in a relationship"
            ]);

        } else {

            if (isset($incoming_requests[0])){
                $response_array = [];
    
                foreach($incoming_requests as $request){
    
                    if ($request -> requester_user -> connection_status == "false"){
                            // Using the belongsTo relation method requester_user() and responder_user()
                            $requester_email = $request -> requester_user -> email; 
                            $requester_name = $request -> requester_user -> username;
                            $responder_email = $request -> responder_user ->email;
                            $response_array[] = [
                                "id" => $request -> id,
                                "requester" => $requester_email,
                                "requester_name" => $requester_name,
                                "responder" => $responder_email,
                                "status" => $request->status
                            ]; 
                    }
                }
                
                if (count($response_array) > 0){
                    return response() -> json([
                        "status" => "success",
                        "requests" => $response_array
                    ]); 
                } else {
                    return response() -> json([
                        "status" => "No requests",
                        "message" => "You don't have any new requests"
                    ]);
                }
    
    
            } else {
                return response() -> json([
                    "status" => "No requests",
                    "message" => "You don't have any new requests"
                ]);
            }
        }

    }


    // receiving end of a request
    // accept - reject a request (Change the value of status to [accepted, rejected])
    public function respond_to_request(Request $request){ 
        $request -> validate([
            'request_id' => 'required|integer', // on display of requests we will also have the details  of each request
            'response' => 'required|in:rejected,accepted'
        ]);

        $pending_request = Connection::find($request->request_id);
        if ($pending_request){
            if ($request -> response === "accepted"){
                // update user's connection status
                
                $requester = User::find($pending_request -> requester);
                $responder = User::find($pending_request -> responder);
                $requester -> connection_status = 'true';
                $responder -> connection_status = 'true';

                $requester -> save();
                $responder -> save();
            }

            // update the status of the connection 
            $pending_request -> status = $request -> response;
            $pending_request -> save();
            return response()->json([
                'status' => 'success',
                'message' => 'Request updated',
                'request' => $pending_request, 
            ]);
        } else {
            return response() -> json([
                "status" => "failed",
                "message" => "Error finding connection"
            ], 400);
        }

    }

    // Change connection status to disconnected
    // Change user's connection_status to false
    public function disconnect(Request $request){
        $request -> validate([
            'connection_id' => 'required|integer', 
        ]);
        $user = Auth::user(); // this is not a token this gets everything except for hidden items
        $connection = Connection::find($request->connection_id);
        try {
            if ($connection && ($connection->requester === $user->id || $connection->responder === $user->id)){

                $user1 = User::find($connection -> responder);
                $user2 = User::find($connection -> requester);
                
                $connection -> status = "disconnected";
                $user1 -> connection_status = 'false';
                $user1 -> couple_survey_status = 'incomplete';
                
                $user2 -> connection_status = 'false';
                $user2 -> couple_survey_status = 'incomplete';
    
                $connection -> save();
                $user1 -> save();
                $user2 -> save();

            return response() -> json([
                "status" => "success",
                "message" => "Disconnected successfully",
                "connection" => $connection,
                "first user" => $user1,
                "second iser" => $user2
            ]);
            

            } else {
                return response() -> json([
                    "status" => "failed",
                    "message" => "Error finding your connection",
                ]);
            }
        } catch (\Throwable $th) {
            return $th;
        }
        
    }

}
