<x-filament-panels::page>
    @vite('plugins/webkul/point-of-sale/resources/js/till/main.js')

    <div
        id="pos-till"
        wire:ignore
        data-sync-endpoint="{{ $this->syncEndpoint() }}"
        data-registers-endpoint="{{ $this->registersEndpoint() }}"
    ></div>
</x-filament-panels::page>
