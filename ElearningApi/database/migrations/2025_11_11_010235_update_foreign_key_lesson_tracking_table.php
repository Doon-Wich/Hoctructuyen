<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('lesson_tracking', function (Blueprint $table) {
            // Xóa khóa ngoại cũ theo tên gốc trong MySQL
            $table->dropForeign('lesson_tracking_ibfk_2');

            // Tạo lại khóa ngoại với hành vi ON DELETE CASCADE
            $table->foreign('lesson_id')
                  ->references('id')
                  ->on('lesson')
                  ->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('lesson_tracking', function (Blueprint $table) {
            // Xóa khóa ngoại cascade
            $table->dropForeign(['lesson_id']);

            // Tạo lại khóa ngoại cũ (không có cascade)
            $table->foreign('lesson_id')
                  ->references('id')
                  ->on('lesson');
        });
    }
};
