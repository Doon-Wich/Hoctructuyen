<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Document extends Model
{
    use HasFactory;

    protected $table = 'documents';

    protected $fillable = [
        'lesson_id',
        'file_path',
        'original_name',
        'file_type',
        'status',
        'processed_at',
    ];

    protected $casts = [
        'processed_at' => 'datetime',
    ];

    /**
     * Một Document thuộc về một Lesson
     */
    public function lesson()
    {
        return $this->belongsTo(Lesson::class);
    }

    /**
     * Một document có nhiều vector entries (chunk embeddings)
     */
    public function vectorEntries()
    {
        return $this->hasMany(VectorEntry::class);
    }
}
