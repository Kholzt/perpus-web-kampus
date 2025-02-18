<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Dashboard') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="grid md:grid-cols-3 sm:grid-cols-2 grid-cols-1 gap-4">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-6 ">
                    <h6>Buku</h6>
                    <h1 class="text-4xl">20</h1>
                    <p class="text-gray-600 text-sm">Semua Buku yang tercatat di sistem</p>
                </div>
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-6 ">
                    <h6>Anggota</h6>
                    <h1 class="text-4xl">20</h1>
                    <p class="text-gray-600 text-sm">Semua Anggota yang tercatat di sistem</p>
                </div>
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-6 ">
                    <h6>Petugas</h6>
                    <h1 class="text-4xl">20</h1>
                    <p class="text-gray-600 text-sm">Semua Petugas yang tercatat di sistem</p>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
