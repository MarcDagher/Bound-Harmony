<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AiResponse extends Model
{
    use HasFactory;

    protected $filable = [
        'user_prompt_id',
        'response'   
    ];
}