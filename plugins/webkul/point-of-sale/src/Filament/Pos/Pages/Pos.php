<?php

namespace Webkul\PointOfSale\Filament\Pos\Pages;

use BackedEnum;
use Filament\Pages\Page;

class Pos extends Page
{
    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-shopping-cart';

    protected static ?string $slug = 'pos';

    protected string $view = 'point-of-sale::filament.pos.pages.till';

    protected static bool $shouldRegisterNavigation = false;

    public function getTitle(): string
    {
        return __('point-of-sale::filament/pos/pages/terminal.title');
    }

    public function syncEndpoint(): string
    {
        return route('point-of-sale.till.orders.sync');
    }

    public function registersEndpoint(): string
    {
        return route('point-of-sale.till.registers');
    }
}
