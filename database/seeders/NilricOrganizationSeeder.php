<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Str;
use RuntimeException;
use Webkul\Employee\Models\Department;
use Webkul\Employee\Models\Employee;
use Webkul\Employee\Models\EmployeeJobPosition;
use Webkul\Security\Enums\PermissionType;
use Webkul\Security\Models\Permission;
use Webkul\Security\Models\Role;
use Webkul\Security\Models\User;
use Webkul\Support\Models\Company;

class NilricOrganizationSeeder extends Seeder
{
    /**
     * Department hierarchy (parent departments must be listed first).
     * Engineering is split into its three sections from the org chart.
     *
     * @var array<string, string|null>
     */
    private const DEPARTMENTS = [
        'Administration & Human Resource' => null,
        'Business Development'            => null,
        'Technical ICT'                   => null,
        'Finance'                         => null,
        'Medical Projects'                => null,
        'Engineering'                     => null,
        'Building & Civil Projects'       => 'Engineering',
        'Electrical & Telecommunication'  => 'Engineering',
        'Mechanical Engineering'          => 'Engineering',
    ];

    /**
     * Job positions mapped to their department (null = company level).
     *
     * @var array<string, array{department: string|null, description: string}>
     */
    private const POSITIONS = [
        'Managing Director'                        => ['department' => null, 'description' => 'Top management. Leads Nilric General Traders, sets company direction and makes major business decisions.'],
        'General Manager'                          => ['department' => null, 'description' => 'Reports to the Managing Director. Coordinates overall company activities and ensures departmental policies are implemented.'],
        'QSHE'                                     => ['department' => null, 'description' => 'Quality, Safety, Health and Environment. Reports to the General Manager; ensures quality standards, occupational health & safety and environmental compliance.'],
        'Operations Manager'                       => ['department' => null, 'description' => 'Reports to the General Manager. Oversees day-to-day operations across the six main departments.'],
        'Administration / Human Resource'          => ['department' => 'Administration & Human Resource', 'description' => 'Leads Administration and Human Resource: employee records, recruitment, staff welfare, office administration and policy compliance.'],
        'Business Development Manager'             => ['department' => 'Business Development', 'description' => 'Leads Business Development: tender and sales & marketing teams.'],
        'Tender Team'                              => ['department' => 'Business Development', 'description' => 'Identifies tender opportunities, prepares documents, quotations and bids, and follows up results. Reports to the Business Development Manager.'],
        'Sales & Marketing Team'                   => ['department' => 'Business Development', 'description' => 'Promotes products/services, identifies customers, maintains client relationships. Reports to the Business Development Manager.'],
        'Technical ICT Manager'                    => ['department' => 'Technical ICT', 'description' => 'Leads Technical ICT: systems, hardware/software, networks and client/internal technical support.'],
        'Technical ICT Team'                       => ['department' => 'Technical ICT', 'description' => 'ICT installation, maintenance, network configuration and troubleshooting. Reports to the Technical ICT Manager.'],
        'Finance Manager'                          => ['department' => 'Finance', 'description' => 'Leads Finance: financial records, income/expenditure, budgets, payments and cash-flow monitoring.'],
        'Finance Team'                             => ['department' => 'Finance', 'description' => 'Financial records and reports, payments and accounting. Reports to the Finance Manager.'],
        'Medical Project Manager'                  => ['department' => 'Medical Projects', 'description' => 'Leads the Medical Project department and its medical business operations.'],
        'Medical Team'                             => ['department' => 'Medical Projects', 'description' => 'Implementation and coordination of medical projects and services. Reports to the Medical Project Manager.'],
        'Engineering Department'                   => ['department' => 'Engineering', 'description' => 'Leads Engineering and reports to the Operations Manager.'],
        'Building & Civil Projects Manager'        => ['department' => 'Building & Civil Projects', 'description' => 'Leads building construction and civil engineering works.'],
        'Civil Engineering Team'                   => ['department' => 'Building & Civil Projects', 'description' => 'Civil engineering activities and project implementation support. Reports to the Building & Civil Projects Manager.'],
        'Electrical and Telecommunication Manager' => ['department' => 'Electrical & Telecommunication', 'description' => 'Leads electrical installation, electrical systems and telecommunication works.'],
        'Electrical and Telecommunication Team'    => ['department' => 'Electrical & Telecommunication', 'description' => 'Technical execution, installation, maintenance and servicing of electrical/telecom systems. Reports to the Electrical and Telecommunication Manager.'],
        'Mechanical Engineering Manager'           => ['department' => 'Mechanical Engineering', 'description' => 'Leads mechanical engineering projects and related technical activities.'],
        'Mechanical Engineering Team'              => ['department' => 'Mechanical Engineering', 'description' => 'Mechanical installations, maintenance and repairs. Reports to the Mechanical Engineering Manager.'],
    ];

    /**
     * Positions renamed to match current company terminology.
     * Used to rename an existing record instead of duplicating it.
     *
     * @var array<string, string>
     */
    private const POSITION_ALIASES = [
        'QSHE'               => 'QHSE',
        'Operations Manager' => 'Operation Manager',
    ];

    /**
     * @var array<string, string>
     */
    private const APPLICATION_MODULES = [
        'employees'    => 'employee',
        'time-off'     => 'time_off',
        'recruitments' => 'recruitment',
        'sales'        => 'sale',
        'purchases'    => 'purchase',
        'inventories'  => 'inventory',
        'maintenance'  => 'maintenance',
        'projects'     => 'project',
        'timesheets'   => 'timesheet',
        'accounts'     => 'account',
        'accounting'   => 'accounting',
        'invoices'     => 'invoice',
        'payments'     => 'payment',
        'products'     => 'product',
        'contacts'     => 'contact',
        'partners'     => 'partner',
    ];

    private const PERMISSION_ACTIONS = [
        'view_any', 'view', 'create', 'update', 'delete', 'delete_any',
        'restore', 'restore_any', 'reorder',
    ];

    /**
     * Roles (Spatie) created from the org chart.
     * level: executive = full access, manager = full access within scope,
     * team = view/create/update own work only, read = view only.
     *
     * @var array<string, array{modules: list<string>, level: string}>
     */
    private const ROLE_PROFILES = [
        // Top management
        'Managing Director'                        => ['modules' => ['employees', 'time-off', 'recruitments', 'sales', 'purchases', 'inventories', 'maintenance', 'projects', 'timesheets', 'accounts', 'accounting', 'invoices', 'payments', 'products', 'contacts', 'partners'], 'level' => 'executive'],
        'General Manager'                          => ['modules' => ['employees', 'time-off', 'recruitments', 'sales', 'purchases', 'inventories', 'maintenance', 'projects', 'timesheets', 'accounts', 'accounting', 'invoices', 'payments', 'products', 'contacts', 'partners'], 'level' => 'executive'],
        'QSHE'                                     => ['modules' => ['employees', 'projects', 'timesheets', 'maintenance'], 'level' => 'read'],
        'Operations Manager'                       => ['modules' => ['employees', 'time-off', 'recruitments', 'sales', 'purchases', 'inventories', 'maintenance', 'projects', 'timesheets', 'accounts', 'accounting', 'invoices', 'payments', 'products', 'contacts', 'partners'], 'level' => 'executive'],

        // Department managers
        'Administration & Human Resource Manager'  => ['modules' => ['employees', 'time-off', 'recruitments', 'contacts', 'partners'], 'level' => 'manager'],
        'Business Development Manager'             => ['modules' => ['sales', 'products', 'contacts', 'partners', 'projects', 'employees', 'time-off'], 'level' => 'manager'],
        'Technical ICT Manager'                    => ['modules' => ['employees', 'projects', 'timesheets', 'maintenance', 'time-off'], 'level' => 'manager'],
        'Finance Manager'                          => ['modules' => ['accounts', 'accounting', 'invoices', 'payments', 'contacts', 'partners', 'employees', 'time-off'], 'level' => 'manager'],
        'Medical Project Manager'                  => ['modules' => ['projects', 'timesheets', 'purchases', 'products', 'inventories', 'maintenance', 'employees', 'time-off'], 'level' => 'manager'],
        'Engineering Department Head'              => ['modules' => ['projects', 'timesheets', 'purchases', 'products', 'inventories', 'maintenance', 'employees', 'time-off'], 'level' => 'manager'],

        // Engineering section managers
        'Building & Civil Projects Manager'        => ['modules' => ['projects', 'timesheets', 'purchases', 'products', 'inventories', 'maintenance', 'employees', 'time-off'], 'level' => 'manager'],
        'Electrical and Telecommunication Manager' => ['modules' => ['projects', 'timesheets', 'purchases', 'products', 'inventories', 'maintenance', 'employees', 'time-off'], 'level' => 'manager'],
        'Mechanical Engineering Manager'           => ['modules' => ['projects', 'timesheets', 'purchases', 'products', 'inventories', 'maintenance', 'employees', 'time-off'], 'level' => 'manager'],

        // Teams (view/create/update own work only)
        'Tender Team'                              => ['modules' => ['employees', 'time-off', 'projects'], 'level' => 'team'],
        'Sales & Marketing Team'                   => ['modules' => ['employees', 'time-off', 'sales', 'contacts', 'partners'], 'level' => 'team'],
        'Technical ICT Team'                       => ['modules' => ['employees', 'time-off', 'projects', 'maintenance'], 'level' => 'team'],
        'Finance Team'                             => ['modules' => ['employees', 'time-off', 'invoices', 'payments', 'accounting'], 'level' => 'team'],
        'Medical Team'                             => ['modules' => ['employees', 'time-off', 'projects', 'timesheets'], 'level' => 'team'],
        'Civil Engineering Team'                   => ['modules' => ['employees', 'time-off', 'projects', 'timesheets'], 'level' => 'team'],
        'Electrical and Telecommunication Team'    => ['modules' => ['employees', 'time-off', 'projects', 'maintenance'], 'level' => 'team'],
        'Mechanical Engineering Team'              => ['modules' => ['employees', 'time-off', 'projects', 'maintenance'], 'level' => 'team'],
    ];

    /**
     * Maps a position to the role given to its employees.
     * 'Engineering Department' (position) uses the head role name.
     *
     * @var array<string, string>
     */
    private const POSITION_ROLES = [
        'Engineering Department'                   => 'Engineering Department Head',
        'Administration / Human Resource'          => 'Administration & Human Resource Manager',
    ];

    /**
     * Reporting lines: manager position => positions reporting to them.
     *
     * @var array<string, list<string>>
     */
    private const REPORTING_LINES = [
        'Managing Director'  => ['General Manager'],
        'General Manager'    => ['QSHE', 'Operations Manager'],
        'Operations Manager' => [
            'Administration / Human Resource',
            'Business Development Manager',
            'Technical ICT Manager',
            'Finance Manager',
            'Medical Project Manager',
            'Engineering Department',
        ],
        'Business Development Manager' => ['Tender Team', 'Sales & Marketing Team'],
        'Technical ICT Manager'        => ['Technical ICT Team'],
        'Finance Manager'              => ['Finance Team'],
        'Medical Project Manager'      => ['Medical Team'],
        'Engineering Department'       => [
            'Building & Civil Projects Manager',
            'Electrical and Telecommunication Manager',
            'Mechanical Engineering Manager',
        ],
        'Building & Civil Projects Manager'        => ['Civil Engineering Team'],
        'Electrical and Telecommunication Manager' => ['Electrical and Telecommunication Team'],
        'Mechanical Engineering Manager'           => ['Mechanical Engineering Team'],
    ];

    public function run(): void
    {
        $company = $this->resolveCompany();

        $creatorId = User::query()
            ->where('default_company_id', $company->id)
            ->value('id') ?? User::query()->value('id');

        $departments = $this->seedDepartments($company, $creatorId);
        $positions = $this->seedPositions($company, $creatorId, $departments);
        $mappedEmployees = $this->mapExistingEmployees($company, $departments, $positions);

        $this->assignDepartmentManagers($departments, $mappedEmployees);
        $this->assignReportingLines($mappedEmployees);
        $this->seedRoleTemplates();
        $this->assignEmployeeRoles($mappedEmployees);
    }

    private function resolveCompany(): Company
    {
        $companyId = config('nilric.company_id');

        if ($companyId !== null && $companyId !== '') {
            $company = Company::query()->find((int) $companyId);

            if (! $company) {
                throw new RuntimeException('The configured NILRIC_COMPANY_ID does not match an active company.');
            }

            return $company;
        }

        $companies = Company::query()->orderBy('id')->get();
        $nilricCompanies = $companies->filter(fn (Company $company) => Str::contains(Str::lower($company->name), 'nilric'));

        if ($nilricCompanies->count() === 1) {
            return $nilricCompanies->first();
        }

        if ($nilricCompanies->count() > 1) {
            throw new RuntimeException('Multiple Nilric companies were found. Set NILRIC_COMPANY_ID to the company that owns this organization chart.');
        }

        if ($companies->count() === 1) {
            return $companies->first();
        }

        if ($companies->isEmpty()) {
            throw new RuntimeException('Create the Nilric company before seeding its organization chart.');
        }

        throw new RuntimeException('Multiple companies were found and none is named Nilric. Set NILRIC_COMPANY_ID before seeding the organization chart.');
    }

    /** @return array<string, Department> */
    private function seedDepartments(Company $company, ?int $creatorId): array
    {
        $departments = [];

        foreach (self::DEPARTMENTS as $name => $parentName) {
            $department = Department::withTrashed()
                ->where('company_id', $company->id)
                ->where('name', $name)
                ->first() ?? new Department;

            $department->forceFill([
                'name'       => $name,
                'company_id' => $company->id,
                'creator_id' => $department->creator_id ?? $creatorId,
                'parent_id'  => $parentName ? $departments[$parentName]->id : null,
                'color'      => '#123f78',
            ]);

            if ($department->trashed()) {
                $department->restore();
            }

            $department->save();
            $departments[$name] = $department;
        }

        return $departments;
    }

    /**
     * @param  array<string, Department>  $departments
     * @return array<string, EmployeeJobPosition>
     */
    private function seedPositions(Company $company, ?int $creatorId, array $departments): array
    {
        $positions = [];

        foreach (self::POSITIONS as $name => $details) {
            $position = EmployeeJobPosition::withTrashed()
                ->where('company_id', $company->id)
                ->where('name', $name)
                ->first();

            // Rename a position seeded under its old name instead of duplicating it.
            if (! $position && isset(self::POSITION_ALIASES[$name])) {
                $position = EmployeeJobPosition::withTrashed()
                    ->where('company_id', $company->id)
                    ->where('name', self::POSITION_ALIASES[$name])
                    ->first();
            }

            $position ??= new EmployeeJobPosition;

            $position->forceFill([
                'name'          => $name,
                'description'   => $details['description'],
                'department_id' => $details['department'] ? $departments[$details['department']]->id : null,
                'company_id'    => $company->id,
                'creator_id'    => $position->creator_id ?? $creatorId,
                'is_active'     => true,
            ]);

            if ($position->trashed()) {
                $position->restore();
            }

            $position->save();
            $positions[$name] = $position;
        }

        return $positions;
    }

    /**
     * @param  array<string, Department>  $departments
     * @param  array<string, EmployeeJobPosition>  $positions
     * @return array<string, list<int>>
     */
    private function mapExistingEmployees(Company $company, array $departments, array $positions): array
    {
        $mappedEmployees = [];

        foreach (Employee::withoutGlobalScopes()->whereNull('deleted_at')->get() as $employee) {
            if ($employee->company_id && $employee->company_id !== $company->id) {
                continue;
            }

            $title = Str::lower(implode(' ', array_filter([
                $employee->job_title,
                $employee->job?->name,
            ])));

            $positionName = match (true) {
                Str::contains($title, 'managing director')                                                                  => 'Managing Director',
                Str::contains($title, 'general manager')                                                                    => 'General Manager',
                Str::contains($title, ['operation manager', 'operations manager'])                                          => 'Operations Manager',
                Str::contains($title, ['qshe', 'qhse', 'quality, health, safety'])                                          => 'QSHE',
                Str::contains($title, ['administration', 'administrative', 'hr manager', 'human resource'])                 => 'Administration / Human Resource',
                Str::contains($title, ['business development manager', 'business development'])                             => 'Business Development Manager',
                Str::contains($title, 'tender')                                                                             => 'Tender Team',
                Str::contains($title, ['sales', 'marketing'])                                                               => 'Sales & Marketing Team',
                Str::contains($title, ['technical manager', 'ict manager', 'it manager'])                                   => 'Technical ICT Manager',
                Str::contains($title, ['developer', 'software engineer', 'qa engineer', 'ux designer', 'data scientist'])   => 'Technical ICT Team',
                Str::contains($title, 'finance manager')                                                                    => 'Finance Manager',
                Str::contains($title, 'finance')                                                                            => 'Finance Team',
                Str::contains($title, ['medical project manager', 'medical projects manager'])                              => 'Medical Project Manager',
                Str::contains($title, ['medical team', 'medical officer'])                                                  => 'Medical Team',
                Str::contains($title, ['engineering department manager', 'engineering department', 'engineering director']) => 'Engineering Department',
                Str::contains($title, ['building', 'civil']) && Str::contains($title, 'manager')                            => 'Building & Civil Projects Manager',
                Str::contains($title, ['building', 'civil'])                                                                => 'Civil Engineering Team',
                Str::contains($title, ['electrical', 'telecommunication']) && Str::contains($title, 'manager')              => 'Electrical and Telecommunication Manager',
                Str::contains($title, ['electrical', 'telecommunication'])                                                  => 'Electrical and Telecommunication Team',
                Str::contains($title, 'mechanical') && Str::contains($title, 'manager')                                     => 'Mechanical Engineering Manager',
                Str::contains($title, 'mechanical')                                                                         => 'Mechanical Engineering Team',
                default                                                                                                     => null,
            };

            if (! $positionName) {
                continue;
            }

            $departmentName = self::POSITIONS[$positionName]['department'];

            Employee::withoutGlobalScopes()
                ->whereKey($employee->id)
                ->update([
                    'company_id'    => $employee->company_id ?? $company->id,
                    'department_id' => $departmentName ? $departments[$departmentName]->id : null,
                    'job_id'        => $positions[$positionName]->id,
                ]);

            $mappedEmployees[$positionName][] = $employee->id;
        }

        return $mappedEmployees;
    }

    /**
     * @param  array<string, Department>  $departments
     * @param  array<string, list<int>>  $mappedEmployees
     */
    private function assignDepartmentManagers(array $departments, array $mappedEmployees): void
    {
        foreach ([
            'Administration & Human Resource' => 'Administration / Human Resource',
            'Business Development'            => 'Business Development Manager',
            'Technical ICT'                   => 'Technical ICT Manager',
            'Finance'                         => 'Finance Manager',
            'Medical Projects'                => 'Medical Project Manager',
            'Engineering'                     => 'Engineering Department',
            'Building & Civil Projects'       => 'Building & Civil Projects Manager',
            'Electrical & Telecommunication'  => 'Electrical and Telecommunication Manager',
            'Mechanical Engineering'          => 'Mechanical Engineering Manager',
        ] as $departmentName => $positionName) {
            $managerId = $mappedEmployees[$positionName][0] ?? null;

            if ($managerId) {
                $departments[$departmentName]->forceFill(['manager_id' => $managerId])->save();
            }
        }
    }

    /**
     * @param  array<string, list<int>>  $mappedEmployees
     */
    private function assignReportingLines(array $mappedEmployees): void
    {
        foreach (self::REPORTING_LINES as $managerPosition => $reportsTo) {
            $managerIds = $mappedEmployees[$managerPosition] ?? [];

            if (! $managerIds) {
                continue;
            }

            foreach ($reportsTo as $reportPosition) {
                foreach ($mappedEmployees[$reportPosition] ?? [] as $reportId) {
                    Employee::withoutGlobalScopes()->whereKey($reportId)->update(['parent_id' => $managerIds[0]]);
                }
            }
        }
    }

    private function seedRoleTemplates(): void
    {
        $permissionNames = Permission::query()
            ->where('guard_name', 'web')
            ->pluck('name');

        foreach (self::ROLE_PROFILES as $name => $profile) {
            $role = Role::query()->firstOrCreate([
                'name'       => $name,
                'guard_name' => 'web',
            ]);

            $allowedActions = match ($profile['level']) {
                'executive', 'manager' => self::PERMISSION_ACTIONS,
                'team'                 => ['view_any', 'view', 'create', 'update'],
                default                => ['view_any', 'view'],
            };

            $permissions = $permissionNames->filter(fn (string $permission) => $this->permissionMatchesProfile(
                $permission,
                $profile['modules'],
                $allowedActions,
                in_array($profile['level'], ['executive', 'manager'], true),
            ))->values()->all();

            $role->syncPermissions($permissions);
        }
    }

    /**
     * @param  array<string, list<int>>  $mappedEmployees
     */
    private function assignEmployeeRoles(array $mappedEmployees): void
    {
        $roles = Role::query()
            ->where('guard_name', 'web')
            ->whereIn('name', array_keys(self::ROLE_PROFILES))
            ->get()
            ->keyBy('name');

        foreach ($mappedEmployees as $positionName => $employeeIds) {
            $roleName = self::POSITION_ROLES[$positionName] ?? $positionName;
            $role = $roles->get($roleName);

            if (! $role) {
                continue;
            }

            $profile = self::ROLE_PROFILES[$roleName] ?? null;
            $permissionScope = match ($profile['level'] ?? 'team') {
                'executive' => PermissionType::GLOBAL,
                'manager'   => PermissionType::GROUP,
                default     => PermissionType::INDIVIDUAL,
            };

            $userIds = Employee::withoutGlobalScopes()
                ->whereKey($employeeIds)
                ->whereNotNull('user_id')
                ->pluck('user_id')
                ->unique();

            foreach ($userIds as $userId) {
                $user = User::query()->find($userId);

                if (! $user || $user->getRoleNames()->map(fn (string $name) => Str::lower($name))->intersect(Role::getSystemRoleNames())->isNotEmpty()) {
                    continue;
                }

                $user->assignRole($role);

                // Scoped permissions: executives see all, managers their team, staff their own records.
                if ($user->resource_permission !== $permissionScope) {
                    $user->forceFill(['resource_permission' => $permissionScope])->saveQuietly();
                }
            }
        }
    }

    /**
     * @param  array<int, string>  $modules
     * @param  array<int, string>  $allowedActions
     */
    private function permissionMatchesProfile(string $permission, array $modules, array $allowedActions, bool $includePages): bool
    {
        foreach ($modules as $module) {
            $permissionModule = self::APPLICATION_MODULES[$module] ?? $module;

            if ($includePages && Str::startsWith($permission, 'page_'.$permissionModule.'_')) {
                return true;
            }

            foreach ($allowedActions as $action) {
                if (Str::startsWith($permission, $action.'_')
                    && Str::startsWith(Str::after($permission, $action.'_'), $permissionModule.'_')) {
                    return true;
                }
            }
        }

        return false;
    }
}
