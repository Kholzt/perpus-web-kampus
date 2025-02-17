<?php

use App\Http\Controllers\BooksController;
use App\Http\Controllers\MembersController;
use App\Http\Controllers\OfficersController;
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('landing');
});

Route::prefix("admin")->middleware("auth")->group(function () {
    Route::get('/dashboard', function () {
        return view('dashboard');
    })->name("dashboard");
    Route::resource("books", BooksController::class);
    Route::resource("members", MembersController::class);
    Route::resource("officers", OfficersController::class);
});

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__ . '/auth.php';
