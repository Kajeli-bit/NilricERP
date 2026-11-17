<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Webkul\Security\Models\Role;
use Webkul\Security\Models\User;
use Webkul\Support\Models\Company;

class NilricManagerUsersSeeder extends Seeder
{
    /**
     * Manager accounts: [role name, email, password].
     */
    private const USERS = [
        ['Managing Director', 'user1@nilric.co.tz', 'user1@nilric.co.tz'],
        ['General Manager', 'user2@nilric.co.tz', 'user2@nilric.co.tz'],
        ['QHSE', 'user3@nilric.co.tz', 'user3@nilric.co.tz'],
        ['Operation Manager', 'user4@nilric.co.tz', 'user4@nilric.co.tz'],
        ['Administration & Human Resource Manager', 'user5@nilric.co.tz', 'user5@nilric.co.tz'],
        ['Business Development Manager', 'user6@nilric.co.tz', 'user6@nilric.co.tz'],
        ['Technical ICT Manager', 'user7@nilric.co.tz', 'user7@nilric.co.tz'],
        ['Finance Manager', 'user8@nilric.co.tz', 'user8@nilric.co.tz'],
        ['Medical Project Manager', 'user9@nilric.co.tz', 'user9@nilric.co.tz'],
        ['Building & Civil Projects Manager', 'user10@nilric.co.tz', 'user10@nilric.co.tz'],
        ['Electrical and Telecommunication Manager', 'user11@nilric.co.tz', 'user11@nilric.co.tz'],
        ['Mechanical Engineering Manager', 'user12@nilric.co.tz', 'user12@nilric.co.tz'],
    ];

    public function run(): void
    {
        $company = Company::query()->orderBy('id')->firstOrFail();

        foreach (self::USERS as [$roleName, $email, $password]) {
            $role = Role::query()->where('guard_name', 'web')->where('name', $roleName)->firstOrFail();

            $user = User::query()->withTrashed()->updateOrCreate(
                ['email' => $email],
                [
                    'name'               => $roleName,
                    'password'           => Hash::make($password),
                    'is_active'          => true,
                    'default_company_id' => $company->id,
                ],
            );

            $user->restore();
            $user->syncRoles([$role]);
        }
    }
}
