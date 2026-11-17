<?php

use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Support\Facades\Hash;
use Webkul\Security\Enums\PermissionType;
use Webkul\Security\Models\Role;
use Webkul\Security\Models\User;

require_once __DIR__.'/../../../../support/tests/Helpers/TestBootstrapHelper.php';

beforeEach(function () {
    TestBootstrapHelper::ensureERPInstalled();
});

function makeTokenUser(): User
{
    return User::withoutEvents(fn (): User => User::factory()->create());
}

it('revokes every api token when revokeApiTokens is called', function () {
    $user = makeTokenUser();

    $user->createToken('api-token');
    $user->createToken('api-token');

    expect($user->tokens()->count())->toBe(2);

    $user->revokeApiTokens();

    expect($user->tokens()->count())->toBe(0);
});

it('revokes api tokens when a password reset completes', function () {
    $user = makeTokenUser();

    $user->createToken('api-token');

    event(new PasswordReset($user));

    expect($user->tokens()->count())->toBe(0);
});

it('keeps api tokens when the password column is rehashed on a normal save', function () {
    $user = makeTokenUser();

    $this->actingAs($user);

    $user->createToken('api-token');

    $user->password = Hash::make('rehashed-password');

    $user->save();

    expect($user->tokens()->count())->toBe(1);
});

it('sets global resource permission when a user is assigned the super admin role', function () {
    $role = Role::query()->firstOrCreate([
        'name'       => 'super_admin',
        'guard_name' => 'web',
    ]);
    $user = User::factory()->create([
        'resource_permission' => PermissionType::INDIVIDUAL->value,
    ]);

    $user->assignRole($role);

    expect($user->fresh()->resource_permission)->toBe(PermissionType::GLOBAL);
});

it('preserves global resource permission on saves while the super admin role remains', function () {
    $role = Role::query()->firstOrCreate([
        'name'       => 'super_admin',
        'guard_name' => 'web',
    ]);
    $user = User::factory()->create([
        'resource_permission' => PermissionType::INDIVIDUAL->value,
    ]);

    $user->assignRole($role);
    $user->resource_permission = PermissionType::INDIVIDUAL;
    $user->save();

    expect($user->fresh()->resource_permission)->toBe(PermissionType::GLOBAL);
});
