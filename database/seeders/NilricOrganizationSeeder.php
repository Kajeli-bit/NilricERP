<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Str;
use RuntimeException;
use Webkul\Employee\Models\Department;
use Webkul\Employee\Models\Employee;
use Webkul\Employee\Models\EmployeeJobPosition;
use Webkul\Security\Models\Permission;
use Webkul\Security\Models\Role;
use Webkul\Security\Models\User;
use Webkul\Support\Models\Company;

class NilricOrganizationSeeder extends Seeder
{
    private const DEPARTMENTS = [
        'Administration & Human Resource' => null,
        'Business Development'            => null,
        'Technical ICT'                   => null,
        'Finance'                         => null,
        'Medical Projects'                => null,
        'Engineering'                     => null,
    ];

    private const POSITIONS = [
        'Managing Director'                        => ['department' => null, 'description' => 'Leads Nilric General Traders and sets company direction.'],
        'General Manager'                          => ['department' => null, 'description' => 'Reports to the Managing Director and leads the company.'],
        'QHSE'                                     => ['department' => null, 'description' => 'Reports to the Managing Director and oversees quality, health, safety and environment.'],
        'Operation Manager'                        => ['department' => null, 'description' => 'Reports to the General Manager and leads the operational departments.'],
        'Administration / Human Resource'          => ['department' => 'Administration & Human Resource', 'description' => 'Leads Administration and Human Resource.'],
        'Business Development Manager'             => ['department' => 'Business Development', 'description' => 'Leads business development, tender and sales and marketing.'],
        'Tender Team'                              => ['department' => 'Business Development', 'description' => 'Reports to the Business Development Manager.'],
        'Sales & Marketing Team'                   => ['department' => 'Business Development', 'description' => 'Reports to the Business Development Manager.'],
        'Technical Manager ICT'                    => ['department' => 'Technical ICT', 'description' => 'Leads Technical ICT.'],
        'Technical ICT Team'                       => ['department' => 'Technical ICT', 'description' => 'Reports to the Technical Manager ICT.'],
        'Finance Manager'                          => ['department' => 'Finance', 'description' => 'Leads Finance.'],
        'Finance Team'                             => ['department' => 'Finance', 'description' => 'Reports to the Finance Manager.'],
        'Medical Project Manager'                  => ['department' => 'Medical Projects', 'description' => 'Leads the Medical Project.'],
        'Medical Team'                             => ['department' => 'Medical Projects', 'description' => 'Reports to the Medical Project Manager.'],
        'Engineering Department'                   => ['department' => 'Engineering', 'description' => 'Leads Engineering and reports to the Operation Manager.'],
        'Building & Civil Projects Manager'        => ['department' => 'Engineering', 'description' => 'Leads Building & Civil Projects.'],
        'Civil Engineering Team'                   => ['department' => 'Engineering', 'description' => 'Reports to the Building & Civil Projects Manager.'],
        'Electrical and Telecommunication Manager' => ['department' => 'Engineering', 'description' => 'Leads Electrical and Telecommunication.'],
        'Electrical and Telecommunication Team'    => ['department' => 'Engineering', 'description' => 'Reports to the Electrical and Telecommunication Manager.'],
        'Mechanical Engineering Manager'           => ['department' => 'Engineering', 'description' => 'Leads Mechanical Engineering.'],
        'Mechanical Engineering Team'              => ['department' => 'Engineering', 'description' => 'Reports to the Mechanical Engineering Manager.'],
    ];

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

    private const ROLE_PROFILES = [
        'Managing Director'                        => ['modules' => ['employees', 'time-off', 'recruitments', 'sales', 'purchases', 'inventories', 'maintenance', 'projects', 'timesheets', 'accounts', 'accounting', 'invoices', 'payments', 'products', 'contacts', 'partners'], 'level' => 'executive'],
        'General Manager'                          => ['modules' => ['employees', 'time-off', 'recruitments', 'sales', 'purchases', 'inventories', 'maintenance', 'projects', 'timesheets', 'accounts', 'accounting', 'invoices', 'payments', 'products', 'contacts', 'partners'], 'level' => 'executive'],
        'QHSE'                                     => ['modules' => ['employees', 'projects', 'timesheets', 'maintenance'], 'level' => 'read'],
        'Operation Manager'                        => ['modules' => ['employees', 'time-off', 'recruitments', 'sales', 'purchases', 'inventories', 'maintenance', 'projects', 'timesheets', 'accounts', 'accounting', 'invoices', 'payments', 'products', 'contacts', 'partners'], 'level' => 'manager'],
        'Administration & Human Resource Manager'  => ['modules' => ['employees', 'time-off', 'recruitments', 'contacts', 'partners'], 'level' => 'manager'],
        'Business Development Manager'             => ['modules' => ['sales', 'products', 'contacts', 'partners', 'projects'], 'level' => 'manager'],
        'Technical ICT Manager'                    => ['modules' => ['employees', 'projects', 'timesheets', 'maintenance'], 'level' => 'manager'],
        'Finance Manager'                          => ['modules' => ['accounts', 'accounting', 'invoices', 'payments', 'contacts', 'partners'], 'level' => 'manager'],
        'Medical Project Manager'                  => ['modules' => ['projects', 'timesheets', 'purchases', 'products', 'inventories', 'maintenance'], 'level' => 'manager'],
        'Building & Civil Projects Manager'        => ['modules' => ['projects', 'timesheets', 'purchases', 'products', 'inventories', 'maintenance'], 'level' => 'manager'],
        'Electrical and Telecommunication Manager' => ['modules' => ['projects', 'timesheets', 'purchases', 'products', 'inventories', 'maintenance'], 'level' => 'manager'],
        'Mechanical Engineering Manager'           => ['modules' => ['projects', 'timesheets', 'purchases', 'products', 'inventories', 'maintenance'], 'level' => 'manager'],
    ];

    public function run(): void
    {
        $company = Company::query()->orderBy('id')->first();

        if (! $company) {
            throw new RuntimeException('Create the Nilric company before seeding its organization chart.');
        }

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
                ->first() ?? new EmployeeJobPosition;

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
                Str::contains($title, ['operation manager', 'operations manager'])                                          => 'Operation Manager',
                Str::contains($title, ['qhse', 'quality, health, safety'])                                                  => 'QHSE',
                Str::contains($title, ['administration', 'administrative', 'hr manager', 'human resource'])                 => 'Administration / Human Resource',
                Str::contains($title, ['business development manager', 'business development'])                             => 'Business Development Manager',
                Str::contains($title, 'tender')                                                                             => 'Tender Team',
                Str::contains($title, ['sales', 'marketing'])                                                               => 'Sales & Marketing Team',
                Str::contains($title, ['technical manager', 'ict manager', 'it manager'])                                   => 'Technical Manager ICT',
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
            'Technical ICT'                   => 'Technical Manager ICT',
            'Finance'                         => 'Finance Manager',
            'Medical Projects'                => 'Medical Project Manager',
            'Engineering'                     => 'Engineering Department',
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
        $reportingLines = [
            'Managing Director' => ['General Manager', 'QHSE'],
            'General Manager'   => ['Operation Manager'],
            'Operation Manager' => [
                'Administration / Human Resource',
                'Business Development Manager',
                'Technical Manager ICT',
                'Finance Manager',
                'Medical Project Manager',
                'Engineering Department',
            ],
            'Business Development Manager' => ['Tender Team', 'Sales & Marketing Team'],
            'Technical Manager ICT'        => ['Technical ICT Team'],
            'Finance Manager'              => ['Finance Team'],
            'Medical Project Manager'      => ['Medical Team'],
            'Engineering Department'       => [
                'Building & Civil Projects Manager',
                'Civil Engineering Team',
                'Electrical and Telecommunication Manager',
                'Electrical and Telecommunication Team',
                'Mechanical Engineering Manager',
                'Mechanical Engineering Team',
            ],
        ];

        foreach ($reportingLines as $managerPosition => $reportsTo) {
            $managerIds = $mappedEmployees[$managerPosition] ?? [];

            foreach ($reportsTo as $reportPosition) {
                foreach ($mappedEmployees[$reportPosition] ?? [] as $reportId) {
                    if ($managerIds) {
                        Employee::withoutGlobalScopes()->whereKey($reportId)->update(['parent_id' => $managerIds[0]]);
                    }
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
            $role = $roles->get($positionName);

            if (! $role) {
                continue;
            }

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
