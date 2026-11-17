<?php

use Livewire\Livewire;
use Webkul\PointOfSale\Filament\Pos\Pages\Pos;

require_once __DIR__.'/../../../../support/tests/Helpers/TestBootstrapHelper.php';
require_once __DIR__.'/../../../../inventories/tests/Helpers/InventoryHelper.php';
require_once __DIR__.'/../../Helpers/PosHelper.php';

beforeEach(function () {
    TestBootstrapHelper::ensurePluginInstalled('inventories');
    TestBootstrapHelper::ensurePluginInstalled('accounts');
    TestBootstrapHelper::ensurePluginInstalled('point-of-sale');

    $this->user = InventoryHelper::actingAsAdmin();
    $this->actingAs($this->user);
});

it('mounts the pos shell without a session', function () {
    Livewire::test(Pos::class)->assertOk();
});
