<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Assignment extends Model
{
    use HasFactory;

    protected $table = 'assignments';

    public $timestamps = false;

    protected $fillable = [
        'lesson_id',
        'title',
        'description',
        'attachment',
        'deadline',
        'is_programming'
    ];

    // Một bài tập thuộc về 1 lesson
    public function lesson()
    {
        return $this->belongsTo(Lesson::class, 'lesson_id');
    }

    // Một bài tập có nhiều bài nộp
    public function submissions()
    {
        return $this->hasMany(StudentAssignmentSubmission::class, 'assignment_id');
    }
}
