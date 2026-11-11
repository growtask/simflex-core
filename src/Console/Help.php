<?php

namespace Simflex\Core\Console;

use Attribute;

#[Attribute]
class Help
{
    public function __construct(
        public string $help = 'No help provided',
        public ?string $name = null
    ) {
    }
}
