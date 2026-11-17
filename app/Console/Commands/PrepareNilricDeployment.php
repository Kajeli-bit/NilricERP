<?php

namespace App\Console\Commands;

use Database\Seeders\NilricOrganizationSeeder;
use Illuminate\Console\Command;

class PrepareNilricDeployment extends Command
{
    protected $signature = 'nilric:prepare-deploy';

    protected $description = 'Run production migrations and apply the Nilric organization chart';

    public function handle(): int
    {
        $this->info('Running database migrations...');

        $exitCode = $this->call('migrate', [
            '--force'          => true,
            '--no-interaction' => true,
        ]);

        if ($exitCode !== self::SUCCESS) {
            return $exitCode;
        }

        $this->info('Applying the Nilric organization chart...');

        return $this->call('db:seed', [
            '--class'          => NilricOrganizationSeeder::class,
            '--force'          => true,
            '--no-interaction' => true,
        ]);
    }
}
