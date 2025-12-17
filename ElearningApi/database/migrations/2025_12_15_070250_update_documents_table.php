<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('documents', function (Blueprint $table) {
            if (!Schema::hasColumn('documents', 'file_path')) {
                $table->string('file_path')->after('title');
            }
            if (!Schema::hasColumn('documents', 'original_name')) {
                $table->string('original_name')->after('file_path');
            }
            if (!Schema::hasColumn('documents', 'file_type')) {
                $table->string('file_type')->after('original_name');
            }
            if (!Schema::hasColumn('documents', 'status')) {
                $table->enum('status', ['pending', 'processing', 'processed'])->default('pending')->after('file_type');
            }
            if (!Schema::hasColumn('documents', 'processed_at')) {
                $table->timestamp('processed_at')->nullable()->after('status');
            }
        });
    }

    public function down(): void
    {
        Schema::table('documents', function (Blueprint $table) {
            $table->dropColumn(['file_path', 'original_name', 'file_type', 'status', 'processed_at']);
        });
    }
};
