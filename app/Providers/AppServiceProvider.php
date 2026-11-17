<?php

namespace App\Providers;

use Illuminate\Contracts\Auth\Authenticatable;
use Illuminate\Support\Facades\Blade;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;
use Webkul\Security\Models\User;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->bind(Authenticatable::class, User::class);
        $this->registerNativeComponents();
    }

    public function boot(): void
    {
        if (app()->environment('production')) {
            URL::forceScheme('https');
        }
    }

    private function registerNativeComponents(): void
    {
        $componentPath = base_path('vendor/nativephp/mobile/src/Edge/Components');

        if (! is_dir($componentPath)) {
            return;
        }

        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($componentPath, RecursiveDirectoryIterator::SKIP_DOTS)
        );

        foreach ($iterator as $file) {
            if (! $file->isFile() || $file->getExtension() !== 'php') {
                continue;
            }

            $relativePath = substr($file->getPathname(), strlen($componentPath) + 1);
            $classPath = str_replace('\\', '/', substr($relativePath, 0, -4));
            $className = basename($classPath);

            if ($className === 'EdgeComponent') {
                continue;
            }

            $componentClass = 'Native\\Mobile\\Edge\\Components\\'.str_replace('/', '\\', $classPath);

            if (! class_exists($componentClass)) {
                continue;
            }

            $componentAlias = 'native-'.ltrim(strtolower((string) preg_replace('/[A-Z]/', '-$0', $className)), '-');

            Blade::component($componentAlias, $componentClass);
        }
    }
}
