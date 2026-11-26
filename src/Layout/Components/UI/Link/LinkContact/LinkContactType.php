<?php

namespace Simflex\Core\Layout\Components\UI\Link\LinkContact;

enum LinkContactType: string
{
    case Phone = 'phone';
    case Email = 'email';
    case Custom = 'custom';
}
