# Описания, checks и accessibility: review

На базе `3fbc0f9` подготовлены узлы [0010](../../specs/nodes/GITVIEW-SPEC-0010.yaml),
[0011](../../specs/nodes/GITVIEW-SPEC-0011.yaml) и
[0017](../../specs/nodes/GITVIEW-SPEC-0017.yaml); предшественники сохранены.

Независимый reviewer сравнил 0010 SHA-256
`86d27e3cf3217385d16ad8c2798a6d047fb42420696c72acf5a1315537416cc3`
с решением владельца и предшественником. Он указал на пропуски обязательного
охвата поддерживаемых creation paths и атрибуции; автор также уточнил
обязательные templates и индикацию подтверждённого отсутствия секции.
Focused review прошёл для SHA-256
`0945ef8e9937d8b83a68d219726216c11270eaf3d1149eba27feb4e4940ae92d`.

В 0011 первый SHA-256
`3320ca0eec140be9403c516b9fe1e1d14c2e3c4b9a167cde046734398f1f40a7`
не требовал явно показывать review assessment и оба счётчика threads и
различать отсутствие reviews, unavailable assessment и requirement. Автор
исправил, focused review прошёл для SHA-256
`f12b50ecc9d0dac01b1e419271b24cfb5c827e42c8178fa445047c93d1a4b891`.

В 0017 reviewer проверил SHA-256
`760124fc157c78f86ce7f8476c9689323200372ba2b09fe86c6fff33412c666a`
и указал, что assistive description должен отдельно сохранять статус stale,
а не объявлять старый успешный CI текущим. Автор уточнил это; итоговый SHA-256
`5c8fce50d507d111ae0d19de69063d7c7b16fbfa5415e93cb16e49229f8d0fa3`;
повторный focused review подтвердил исправление.

Semantic reviews не подтверждают GitHub API mappings, enforcement шаблонов,
native accessibility или выполнение приложения.
