<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use RuntimeException;
use Webkul\PluginManager\Models\Plugin;

class SetupNilricOrganization extends Command
{
    protected $signature = 'nilric:setup-organization';

    protected $description = 'Install the Nilric organization chart, role templates, and related ERP apps';

    private const MODULES = [
        'employees',
        'contacts',
        'products',
        'accounts',
        'invoices',
        'payments',
        'recruitments',
        'projects',
        'purchases',
        'inventories',
        'maintenance',
        'sales',
        'timesheets',
        'accounting',
        'time-off',
    ];

    private const SEEDED_TABLES = [
        'accounts' => [
            'accounts_account_tags', 'accounts_accounts', 'accounts_incoterms', 'accounts_journals',
            'accounts_payment_due_terms', 'accounts_payment_method_lines', 'accounts_payment_methods',
            'accounts_payment_terms', 'accounts_tax_groups', 'accounts_tax_partition_lines', 'accounts_taxes',
        ],
        'employees' => [
            'activity_plan_templates', 'employees_calendar_attendances', 'employees_calendars',
            'employees_categories', 'employees_departments', 'employees_departure_reasons',
            'employees_employees', 'employees_employment_types', 'employees_job_positions',
            'employees_skill_levels', 'employees_skills', 'employees_skill_types', 'employees_work_locations',
        ],
        'inventories' => [
            'inventories_locations', 'inventories_move_lines', 'inventories_moves', 'inventories_operation_types',
            'inventories_operations', 'inventories_product_quantities', 'inventories_routes',
            'inventories_rules', 'inventories_scraps', 'inventories_warehouses',
        ],
        'products'     => ['products_categories'],
        'projects'     => ['projects_project_stages'],
        'recruitments' => [
            'recruitments_applicant_categories', 'recruitments_degrees',
            'recruitments_refuse_reasons', 'recruitments_stages',
        ],
        'sales' => ['sales_teams'],
    ];

    public function handle(): int
    {
        // The admin panel provider caps execution at 300s; this is a long CLI job, so lift the cap.
        set_time_limit(0);

        $plugins = Plugin::query()->whereIn('name', self::MODULES)->get()->keyBy('name');

        foreach (self::MODULES as $module) {
            if (! $plugins->has($module)) {
                throw new RuntimeException("The {$module} app is not registered in Plugin Manager.");
            }

            if ($plugins[$module]->is_installed) {
                continue;
            }

            foreach (self::SEEDED_TABLES[$module] ?? [] as $table) {
                if (! Schema::hasTable($table) || ! DB::table($table)->exists()) {
                    continue;
                }

                $this->error("Cannot safely install {$module}: its demo seeder would delete existing rows from {$table}. Back up and review that data, then make the seeder non-destructive before retrying.");

                return self::FAILURE;
            }
        }

        foreach (self::MODULES as $module) {
            $plugin = $plugins->get($module);

            if ($plugin->is_installed) {
                $this->line("Already installed: {$module}");

                continue;
            }

            $this->info("Installing {$module}...");

            $exitCode = Artisan::call("{$module}:install", ['--no-interaction' => true]);
            $this->output->write(Artisan::output());

            if ($exitCode !== self::SUCCESS) {
                throw new RuntimeException("Installing the {$module} app failed with exit code {$exitCode}.");
            }

            $plugin->refresh();

            if (! $plugin->is_installed) {
                throw new RuntimeException("The {$module} app installer did not mark the app as installed.");
            }
        }

        $this->info('Refreshing Filament permissions for the installed apps...');

        $exitCode = Artisan::call('shield:generate', [
            '--all'    => true,
            '--option' => 'permissions',
            '--panel'  => 'admin',
        ]);
        $this->output->write(Artisan::output());

        if ($exitCode !== self::SUCCESS) {
            throw new RuntimeException('Regenerating admin access permissions failed.');
        }

        DB::transaction(function (): void {
            $exitCode = Artisan::call('db:seed', [
                '--class' => 'Database\\Seeders\\NilricOrganizationSeeder',
                '--force' => true,
            ]);
            $this->output->write(Artisan::output());

            if ($exitCode !== self::SUCCESS) {
                throw new RuntimeException('Seeding Nilric organization data failed.');
            }
        });

        $this->info('Nilric organization, role templates, and app permissions are ready.');

        return self::SUCCESS;
    }
}
