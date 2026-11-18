<?php

namespace App\Console\Commands;

use Database\Seeders\NilricOrganizationSeeder;
use Illuminate\Console\Command;

class EnsureNilricOrganization extends Command
{
    protected $signature = 'nilric:ensure-organization';

    protected $description = 'Restore missing Nilric departments, positions, and role templates';

    public function handle(NilricOrganizationSeeder $organizationSeeder): int
    {
        if ($organizationSeeder->isOrganizationChartComplete()) {
            $this->info('Nilric organization data is already complete.');

            return self::SUCCESS;
        }

        $this->info('Restoring missing Nilric organization data...');

        return $this->call('db:seed', [
            '--class'          => NilricOrganizationSeeder::class,
            '--force'          => true,
            '--no-interaction' => true,
        ]);
    }
}
