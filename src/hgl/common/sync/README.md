

## Правила написания кода
- Все синхронизируемые классы должны быть наследниками SyncItem.
- Поддерживаемые типы: Базовые (Bool,Byte,Short,Int,String,Bytes,SyncItem), Составные (Array<Базовый тип>,Map<Базовый тип, Базовый тип>)
- Вместо конструктора для инициализации сериализуемых переменных всегда используется метод create. Метод create не вызывается при реконнекте
- Пользовательские действия и/или тики сервера должны всегда вызывать метод помеченный @:sync
- После реконнекта в коробке лежат абсолютно новые объекты (кроме самой коробки), поэтому на события нужно переподписаться. Для каждого объекта вызывается метод restore();
- Инициализация переменных класса, которые не участвуют в синхронизации должна происходить при объявлении или в конструкторе

## TODO

- Поддержка Map
- JSON сериализация