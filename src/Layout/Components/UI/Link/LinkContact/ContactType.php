<?php

namespace Simflex\Core\Layout\Components\UI\Link\LinkContact;

enum ContactType: string
{
    case Phone = 'phone';
    case Email = 'email';
    case Custom = 'custom';
}
