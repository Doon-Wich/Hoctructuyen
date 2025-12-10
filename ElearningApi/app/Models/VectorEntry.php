<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VectorEntry extends Model
{
    use HasFactory;

    protected $table = 'vector_entries';

    protected $fillable = [
        'document_id',
        'lesson_id',
        'course_id',
        'chunk_id',
        'content',
        'embedding',
        'metadata',
    ];

    protected $casts = [
        'embedding' => 'array', // vector array float
        'metadata' => 'array',  // optional: file, token length, etc.
    ];

    /**
     * Chunk belongs to a Document
     */
    public function document()
    {
        return $this->belongsTo(Document::class);
    }

    /**
     * Chunk belongs to a Lesson
     */
    public function lesson()
    {
        return $this->belongsTo(Lesson::class);
    }

    /**
     * Chunk belongs to a Course
     */
    public function course()
    {
        return $this->belongsTo(Course::class);
    }
}
