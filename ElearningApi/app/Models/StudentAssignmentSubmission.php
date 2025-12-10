<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class StudentAssignmentSubmission extends Model
{
    use HasFactory;

    protected $table = 'student_assignment_submission';

    public $timestamps = false;

    protected $fillable = [
        'assignment_id',
        'student_id',
        'content',
        'file_upload',
        'submitted_at',
        'score',
        'teacher_feedback',
        'graded_at',
        'status',
    ];

    public function assignment()
    {
        return $this->belongsTo(Assignment::class, 'assignment_id');
    }

    public function student()
    {
        return $this->belongsTo(User::class, 'student_id');
    }
}
