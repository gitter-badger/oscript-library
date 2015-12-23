﻿#Использовать tempfiles
#Использовать logos
#Использовать strings

#Использовать "../src/core"

Перем юТест;
Перем Распаковщик;
Перем Лог;

Процедура Инициализация()
	
	Распаковщик = Новый МенеджерСинхронизации();
	Лог = Логирование.ПолучитьЛог("oscript.app.gitsync");
	Лог.УстановитьУровень(УровниЛога.Отладка);
	
КонецПроцедуры

Функция ПолучитьСписокТестов(Знач Контекст) Экспорт
	
	юТест = Контекст;
	
	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("Тест_ДолженВыполнитьПолнуюВыгрузку");
	ВсеТесты.Добавить("Тест_ДолженВыгрузитьМодули");
	ВсеТесты.Добавить("Тест_ДолженРазложитьМодули1СПоПапкамСогласноИерархииМетаданных");
	ВсеТесты.Добавить("Тест_ДолженПрочитатьТаблицуВерсийИзХранилища1С");
	ВсеТесты.Добавить("Тест_ДолженПрочитатьФайлПользователейИзХранилища1С");
	ВсеТесты.Добавить("Тест_ДолженПодготовитьРепозитарийКСинхронизацииСХранилищем");
	ВсеТесты.Добавить("Тест_ДолженПрочитатьФайлВерсийСИменамиПользователейИзХранилища1С");
	ВсеТесты.Добавить("ТестДолжен_СинхронизироватьХранилищеКонфигурацийСГит");
	ВсеТесты.Добавить("ТестДолжен_ОпределитьЧтоТребуетсяСинхронизацияСГит");
	ВсеТесты.Добавить("ТестДолжен_ВыполнитьКоммитФайловВГит");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЧтениеФайлаАвторовГит");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьОтсутствиеФайлаAUTHORS");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьДанныеВФайлеAUTHORS");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьНеполнотуВФайлеAUTHORS");
	ВсеТесты.Добавить("ТестДолжен_ВыполнитьGitPush");
	ВсеТесты.Добавить("ТестДолжен_ВыполнитьGitPull");
	
	Возврат ВсеТесты;
	
КонецФункции

Процедура ПослеЗапускаТеста() Экспорт
	ВременныеФайлы.Удалить();
КонецПроцедуры

Функция ПолучитьФайлКонфигурацииИзМакета(Знач ИмяМакета = "") 
	
	Если ИмяМакета = "" Тогда
		ИмяМакета = "ТестовыйФайлКонфигурации";
	КонецЕсли;
	
	
	ФайлТестовойКонфигурации = Новый Файл(ОбъединитьПути(КаталогFixtures(), ИмяМакета + ".cf"));
	
	юТест.Проверить(ФайлТестовойКонфигурации.Существует(), "Файл тестовой конфигурации <"+ФайлТестовойКонфигурации.ПолноеИмя+"> должен существовать");
	
	Возврат ФайлТестовойКонфигурации.ПолноеИмя;
	
КонецФункции

Функция ПолучитьПутьКВременномуФайлуХранилища1С()
	
	ПутьКФайлуХранилища1С = ОбъединитьПути(КаталогFixtures(), "ТестовыйФайлХранилища1С.1CD");
	юТест.ПроверитьИстину(ПроверитьСуществованиеФайлаКаталога(ПутьКФайлуХранилища1С, "Тест_ДолженПолучитьФайлВерсийХранилища - ПутьКФайлуХранилища1С"));
	
	Возврат ПутьКФайлуХранилища1С;
	
КонецФункции

Функция ПроверитьСуществованиеФайлаКаталога(парамПуть, допСообщениеОшибки = "")
	Если Не ЗначениеЗаполнено(парамПуть) Тогда
		Сообщить("Не указан путь <"+допСообщениеОшибки+">");
		Возврат Ложь;
	КонецЕсли;
	
	лфайл = Новый Файл(парамПуть);
	Если Не лфайл.Существует() Тогда
		Сообщить("Не существует файл <"+допСообщениеОшибки+">");
		Возврат Ложь;	
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Функция КаталогFixtures()
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures");
КонецФункции

Процедура Тест_ДолженВыполнитьПолнуюВыгрузку() Экспорт

	КаталогВыгрузки = ВременныеФайлы.СоздатьКаталог();
	МассивФайлов = НайтиФайлы(КаталогВыгрузки, ПолучитьМаскуВсеФайлы());
	юТест.Проверить(МассивФайлов.Количество() = 0, "КаталогВыгрузки должен быть пуст");
	
	ПутьКФайлуКонфигурации = ПолучитьФайлКонфигурацииИзМакета();
	
	Распаковщик.РазобратьФайлКонфигурации(ПутьКФайлуКонфигурации, КаталогВыгрузки, "plain");
	
	ФайлПереименований = Новый Файл(ОбъединитьПути(КаталогВыгрузки, "renames.txt"));
	ФайлКорняМетаданных = Новый Файл(ОбъединитьПути(КаталогВыгрузки, "Configuration.xml"));
	
	юТест.Проверить(ФайлПереименований.Существует(), "Файл переименований должен существовать");
	юТест.Проверить(ФайлКорняМетаданных.Существует(), "Файл корня метаданных должен существовать");
	
КонецПроцедуры

Процедура Тест_ДолженВыгрузитьМодули() Экспорт 
	
	КаталогПлоскойВыгрузки = ВременныеФайлы.СоздатьКаталог();
	Распаковщик.ВыгрузитьМодулиКонфигурации(ПолучитьФайлКонфигурацииИзМакета(), КаталогПлоскойВыгрузки, "plain");
	
	МассивФайлов = НайтиФайлы(КаталогПлоскойВыгрузки,"*.*");
	
	юТест.ПроверитьИстину(МассивФайлов.Количество() > 0, "в каталоге выгрузки модулей 1С <"+КаталогПлоскойВыгрузки+"> должны быть файлы");
КонецПроцедуры

Процедура Тест_ДолженРазложитьМодули1СПоПапкамСогласноИерархииМетаданных() Экспорт 
	
	КаталогПлоскойВыгрузки = ВременныеФайлы.СоздатьКаталог();
	Распаковщик.ВыгрузитьМодулиКонфигурации(ПолучитьФайлКонфигурацииИзМакета(), КаталогПлоскойВыгрузки, "plain");
	
	КаталогИерархическойВыгрузки = ВременныеФайлы.СоздатьКаталог();
	
	Распаковщик.РазложитьМодули1СПоПапкамСогласноИерархииМетаданных(КаталогПлоскойВыгрузки, КаталогИерархическойВыгрузки, "plain");
		
	ФайлПереименований = Новый Файл(КаталогИерархическойВыгрузки + "\renames.txt");
	юТест.ПроверитьИстину(ФайлПереименований.Существует(), "Не удалось разложим модули 1С по иерархии - не существует файл <"+ФайлПереименований.ПолноеИмя+">");
		
	МассивФайлов = НайтиФайлы(КаталогИерархическойВыгрузки,"*.*");
	юТест.ПроверитьИстину(МассивФайлов.Количество() > 0, "в каталоге разложения модулей 1С <"+КаталогИерархическойВыгрузки+"> должны быть файлы");
	
КонецПроцедуры

Процедура Тест_ДолженПрочитатьТаблицуВерсийИзХранилища1С() Экспорт
	
	ФайлХранилища = ПутьКВременномуФайлуХранилища1С();
	ТаблицаИсторииХранилища = Распаковщик.ПрочитатьТаблицуИсторииХранилища(ФайлХранилища);
	юТест.ПроверитьРавенство(ТаблицаИсторииХранилища.Количество(), 3, "таблицаИсторииХранилища.Количество()");
	Для Каждого СтрокаВерсии Из ТаблицаИсторииХранилища Цикл
		Лог.Отладка("" + СтрокаВерсии.Дата + ": " + СтрокаВерсии.НомерВерсии + ": " + СтрокаВерсии.Комментарий);
	КонецЦикла;
	
КонецПроцедуры

Процедура Тест_ДолженПрочитатьФайлПользователейИзХранилища1С() Экспорт
	ФайлХранилища = ПутьКВременномуФайлуХранилища1С();
	ТаблицаПользователей = Распаковщик.ПрочитатьТаблицуПользователейХранилища(ФайлХранилища);
	юТест.ПроверитьРавенство(ТаблицаПользователей.Количество(), 2, "ТаблицаПользователей.Количество()");
	Для Каждого СтрокаВерсии Из ТаблицаПользователей Цикл
		Лог.Отладка("" + СтрокаВерсии.Автор + ": " + СтрокаВерсии.ГУИД_Автора);
	КонецЦикла;
КонецПроцедуры

Процедура Тест_ДолженПодготовитьРепозитарийКСинхронизацииСХранилищем() Экспорт

	ТестФайлХранилища = ПутьКВременномуФайлуХранилища1С();
	
	// запись
	ВыходнойФайл = ВременныеФайлы.СоздатьФайл();
	Распаковщик.СформироватьПервичныйФайлПользователейДляGit(ТестФайлХранилища, ВыходнойФайл);
	// проверка
	Стр = "";
	СчетчикПроверки = 0;
	СтрокиПроверки = Новый Массив;
	СтрокиПроверки.Добавить("Администратор=Администратор <Администратор@localhost>");
	СтрокиПроверки.Добавить("Отладка=Отладка <Отладка@localhost>");
	
	ЧтениеФайла = Новый ЧтениеТекста(ВыходнойФайл, "utf-8");
	
	Попытка
		
		Пока Стр <> Неопределено Цикл
			Стр = ЧтениеФайла.ПрочитатьСтроку();
			Если Стр <> Неопределено Тогда
				юТест.Проверить(СчетчикПроверки < СтрокиПроверки.Количество(), "Количество строк в файле должно совпадать с эталоном");
			Иначе
				Прервать;
			КонецЕсли;
			
			юТест.ПроверитьРавенство(СтрокиПроверки[СчетчикПроверки], Стр, "Строка в файле должна совпадать с эталоном");
			СчетчикПроверки = СчетчикПроверки + 1;
			
		КонецЦикла;
		ЧтениеФайла.Закрыть();
	Исключение
		ОсвободитьОбъект(ЧтениеФайла);
		ВызватьИсключение;
	КонецПопытки;
	
	юТест.ПроверитьРавенство(СчетчикПроверки, СтрокиПроверки.Количество(), "Количество прочитанных строк не соответствует эталону");

КонецПроцедуры

Процедура Тест_ДолженПрочитатьФайлВерсийСИменамиПользователейИзХранилища1С() Экспорт 

	ПутьКФайлуХранилища1С = ПутьКВременномуФайлуХранилища1С();
	
	ТаблицаИсторииХранилища = Распаковщик.ПрочитатьИзХранилищаИсториюКоммитовСАвторами(ПутьКФайлуХранилища1С);
	
	юТест.ПроверитьРавенство(ТаблицаИсторииХранилища.Количество(), 3, "ТаблицаИсторииХранилища.Количество()");
		
	Для Каждого строка Из ТаблицаИсторииХранилища Цикл
		Если ПустаяСтрока(строка.Автор) Тогда
			ВызватьИсключение "Не найден автор коммита - номер версии <"+строка.НомерВерсии+">, комментарий <"+строка.Комментарий+">";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ТестДолжен_ОпределитьЧтоТребуетсяСинхронизацияСГит() Экспорт
	
	ПутьКФайлуХранилища1С = ПутьКВременномуФайлуХранилища1С();
	КаталогРепо = ВременныеФайлы.СоздатьКаталог();
	КаталогИсходников = ОбъединитьПути(КаталогРепо, "src");
	СоздатьКаталог(КаталогИсходников);
	
	РезультатИнициализацииГитЧисло = ИнициализироватьТестовоеХранилищеГит(КаталогРепо);
	юТест.ПроверитьРавенство(0, РезультатИнициализацииГитЧисло, "Инициализация git-хранилища в каталоге: "+КаталогРепо);
	
	СоздатьФайлАвторовГит_ДляТестов(КаталогИсходников);
	юТест.ПроверитьИстину(Новый Файл(ОбъединитьПути(КаталогИсходников, Распаковщик.ИмяФайлаАвторов())).Существует());
	Распаковщик.ЗаписатьФайлВерсийГит(КаталогИсходников,0);
	юТест.ПроверитьИстину(Новый Файл(ОбъединитьПути(КаталогИсходников, Распаковщик.ИмяФайлаВерсииХранилища())).Существует());
	
	юТест.ПроверитьИстину(Распаковщик.ТребуетсяСинхронизироватьХранилищеСГит(ПутьКФайлуХранилища1С, КаталогИсходников));
	
КонецПроцедуры

 
Процедура ТестДолжен_ПроверитьЧтениеФайлаАвторовГит() Экспорт
	
	КаталогРепозитория = ВременныеФайлы.СоздатьКаталог();
	СоздатьФайлАвторовГит_ДляТестов(КаталогРепозитория);
	ИмяФайлаАвторов = ОбъединитьПути(КаталогРепозитория, Распаковщик.ИмяФайлаАвторов());
	
	ТаблицаПользователей = Распаковщик.ПрочитатьФайлАвторовГитВТаблицуПользователей(ИмяФайлаАвторов);
	
	юТест.Проверить(ТаблицаПользователей <> Неопределено, "Таблица пользователей должна быть получена из процедуры ПрочитатьФайлАвторовГит");
	
	юТест.ПроверитьРавенство(ТаблицаПользователей[0].Автор, "Администратор", "Автор первой строки должен иметь значение Администратор");
	юТест.ПроверитьРавенство(ТаблицаПользователей[0].ПредставлениеАвтора, "Администратор <admin@localhost>", "Имя пользователя для Гит в строке 1 должно соответствовать шаблону");
	юТест.ПроверитьРавенство(ТаблицаПользователей[1].Автор, "Отладка", "Автор второй строки должен иметь значение Отладка");
	юТест.ПроверитьРавенство(ТаблицаПользователей[1].ПредставлениеАвтора, "Отладка <debug@localhost>", "Имя пользователя для Гит в строке 2 должно соответствовать шаблону");
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьОтсутствиеФайлаAUTHORS() Экспорт

	КаталогРепозитория = ВременныеФайлы.СоздатьКаталог();
	РезультатИнициализацииГитЧисло = ИнициализироватьТестовоеХранилищеГит(КаталогРепозитория);
	юТест.ПроверитьИстину(РезультатИнициализацииГитЧисло=0, "Инициализация git-хранилища в каталоге: "+КаталогРепозитория);
	
	Распаковщик.ЗаписатьФайлВерсийГит(КаталогРепозитория,0);
	
	ПутьКФайлуХранилища1С = ПолучитьПутьКВременномуФайлуХранилища1С();
	
	ТаблицаИсторииХранилища = Распаковщик.ПрочитатьИзХранилищаИсториюКоммитовСАвторами(ПутьКФайлуХранилища1С);
	Распаковщик.ДополнитьТаблицуХранилищаИнформациейОСигнатуреПользователяВГит(ТаблицаИсторииХранилища, КаталогРепозитория);
	
	// проверка алиасов по таблице истории хранилища
	Лог.Отладка("1. Проверка: Если файл AUTHORS отсутствует -------");
	Для Каждого Стр Из ТаблицаИсторииХранилища Цикл
		ШаблонУтверждения = "алиас пользователя <%1> должен совпадать с эталоном";
		Если Стр.Автор = "Администратор" Тогда
			юТест.ПроверитьРавенство(Стр.ПредставлениеАвтора, "Администратор <Администратор@localhost>", СтроковыеФункции.ПодставитьПараметрыВСтроку(ШаблонУтверждения, Стр.Автор));
		ИначеЕсли Стр.Автор = "Отладка" Тогда
			юТест.ПроверитьРавенство(Стр.ПредставлениеАвтора, "Отладка <Отладка@localhost>", СтроковыеФункции.ПодставитьПараметрыВСтроку(ШаблонУтверждения, Стр.Автор));
		Иначе
			ВызватьИсключение "Неизвестный пользователь: " + Стр.Автор;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьНеполнотуВФайлеAUTHORS() Экспорт

	КаталогРепозитория = ВременныеФайлы.СоздатьКаталог();
	РезультатИнициализацииГитЧисло = ИнициализироватьТестовоеХранилищеГит(КаталогРепозитория);
	юТест.ПроверитьИстину(РезультатИнициализацииГитЧисло=0, "Инициализация git-хранилища в каталоге: "+КаталогРепозитория);
	
	Распаковщик.ЗаписатьФайлВерсийГит(КаталогРепозитория,0);
	
	ПутьКФайлуХранилища1С = ПолучитьПутьКВременномуФайлуХранилища1С();
	
	ФайлАвторов = Новый ЗаписьТекста;
	ФайлАвторов.Открыть(ОбъединитьПути(КаталогРепозитория, Распаковщик.ИмяФайлаАвторов()), "utf-8");
	ФайлАвторов.ЗаписатьСтроку("Администратор=Администратор <admin@localhost>");
	ФайлАвторов.Закрыть();
	
	ТаблицаИсторииХранилища = Распаковщик.ПрочитатьИзХранилищаИсториюКоммитовСАвторами(ПутьКФайлуХранилища1С);
	Распаковщик.ДополнитьТаблицуХранилищаИнформациейОСигнатуреПользователяВГит(ТаблицаИсторииХранилища, КаталогРепозитория);
	
	Для Каждого Стр Из ТаблицаИсторииХранилища Цикл
		ШаблонУтверждения = "алиас пользователя <%1> должен совпадать с эталоном";
		Если Стр.Автор = "Администратор" Тогда
			юТест.ПроверитьРавенство(Стр.ПредставлениеАвтора, "Администратор <admin@localhost>", СтроковыеФункции.ПодставитьПараметрыВСтроку(ШаблонУтверждения, Стр.Автор));
		ИначеЕсли Стр.Автор = "Отладка" Тогда
			юТест.ПроверитьРавенство(Стр.ПредставлениеАвтора, "Отладка <Отладка@localhost>", СтроковыеФункции.ПодставитьПараметрыВСтроку(ШаблонУтверждения, Стр.Автор));
		Иначе
			ВызватьИсключение "Неизвестный пользователь: " + Стр.Автор;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ТестДолжен_ПроверитьДанныеВФайлеAUTHORS() Экспорт

	КаталогРепозитория = ВременныеФайлы.СоздатьКаталог();
	РезультатИнициализацииГитЧисло = ИнициализироватьТестовоеХранилищеГит(КаталогРепозитория);
	юТест.ПроверитьИстину(РезультатИнициализацииГитЧисло=0, "Инициализация git-хранилища в каталоге: "+КаталогРепозитория);
	
	Распаковщик.ЗаписатьФайлВерсийГит(КаталогРепозитория,0);
	
	ПутьКФайлуХранилища1С = ПолучитьПутьКВременномуФайлуХранилища1С();
	ИмяФайлаАвторов = ОбъединитьПути(КаталогРепозитория, Распаковщик.ИмяФайлаАвторов());
	юТест.ПроверитьЛожь(Новый Файл(ИмяФайлаАвторов).Существует());
	СоздатьФайлАвторовГит_ДляТестов(КаталогРепозитория);
	
	ТаблицаПользователейГит = Распаковщик.ПрочитатьТаблицуПользователейХранилища(ПутьКФайлуХранилища1С);
	Распаковщик.ДополнитьТаблицуХранилищаИнформациейОСигнатуреПользователяВГит(ТаблицаПользователейГит, КаталогРепозитория);
	
	ШаблонУтверждения = "алиас пользователя <%1> должен совпадать с эталоном";
	Стр = ТаблицаПользователейГит.Найти("Администратор", "Автор");
	юТест.ПроверитьЛожь(Стр = Неопределено, "Должен найти строку в таблице авторов");
	юТест.ПроверитьРавенство(Стр.ПредставлениеАвтора, "Администратор <admin@localhost>", СтроковыеФункции.ПодставитьПараметрыВСтроку(ШаблонУтверждения, Стр.Автор));
	Стр = ТаблицаПользователейГит.Найти("Отладка", "Автор");
	юТест.ПроверитьРавенство(Стр.ПредставлениеАвтора, "Отладка <debug@localhost>", СтроковыеФункции.ПодставитьПараметрыВСтроку(ШаблонУтверждения, Стр.Автор));

КонецПроцедуры

Процедура ТестДолжен_СинхронизироватьХранилищеКонфигурацийСГит() Экспорт	
	
	ПутьКФайлуХранилища1С = ПутьКВременномуФайлуХранилища1С();
	
	КаталогРепо = ВременныеФайлы.СоздатьКаталог();
	КаталогИсходников = ОбъединитьПути(КаталогРепо, "src");
	СоздатьКаталог(КаталогИсходников);
	
	РезультатИнициализацииГитЧисло = ИнициализироватьТестовоеХранилищеГит(КаталогРепо);
	юТест.ПроверитьИстину(РезультатИнициализацииГитЧисло=0, "Инициализация git-хранилища в каталоге: "+КаталогРепо);
	
	СоздатьФайлАвторовГит_ДляТестов(КаталогИсходников);
	ПроверитьСуществованиеФайлаКаталога(ОбъединитьПути(КаталогИсходников,"AUTHORS"));
	Распаковщик.ЗаписатьФайлВерсийГит(КаталогИсходников,0);
	ПроверитьСуществованиеФайлаКаталога(ОбъединитьПути(КаталогИсходников,"VERSION"));
	
	Распаковщик.СинхронизироватьХранилищеКонфигурацийСГит(КаталогИсходников, ПутьКФайлуХранилища1С);
	
	ИмяФайлаЛогаГит = ВременныеФайлы.НовоеИмяФайла("txt");
	
	ФайлКоманды = ВременныеФайлы.НовоеИмяФайла("cmd");
	ЗаписьФайла = Новый ЗаписьТекста(ФайлКоманды, "cp866");
	ЗаписьФайла.ЗаписатьСтроку("cd /d " + ОбернутьВКавычки(КаталогИсходников));
	ЗаписьФайла.ЗаписатьСтроку("git log --pretty=oneline >"+ОбернутьВКавычки(ИмяФайлаЛогаГит));
	ЗаписьФайла.Закрыть();
	
	КодВозврата = 0;
	ЗапуститьПриложение("cmd.exe /C " + ОбернутьВКавычки(ФайлКоманды), , Истина, КодВозврата);
	юТест.ПроверитьРавенство(0, КодВозврата, "Получение краткого лога хранилища git");
	
	ЛогГит = Новый ЧтениеТекста;
	ЛогГит.Открыть(ИмяФайлаЛогаГит);
	КоличествоКоммитов = 0;
	Пока ЛогГит.ПрочитатьСтроку() <> Неопределено Цикл
		КоличествоКоммитов = КоличествоКоммитов + 1;
	КонецЦикла;
	ЛогГит.Закрыть();
	юТест.ПроверитьРавенство(КоличествоКоммитов, 3, "Количество коммитов в git-хранилище");
	
КонецПроцедуры

Процедура ТестДолжен_ВыполнитьКоммитФайловВГит() Экспорт
	КаталогВыгрузки = ВременныеФайлы.СоздатьКаталог();
	
	МассивФайлов = НайтиФайлы(КаталогВыгрузки, ПолучитьМаскуВсеФайлы());
	юТест.Проверить(МассивФайлов.Количество() = 0, "КаталогВыгрузки должен быть пуст");
	
	ГитПодготовлен = ИнициализироватьТестовоеХранилищеГит(КаталогВыгрузки);
	юТест.ПроверитьРавенство(ГитПодготовлен, 0, "Код возврата git init должен быть равен нулю");
	
	ПутьКФайлуКонфигурации = ПолучитьФайлКонфигурацииИзМакета();

	Распаковщик.РазобратьФайлКонфигурации(ПутьКФайлуКонфигурации, КаталогВыгрузки, "plain");
	
	МассивФайлов = НайтиФайлы(КаталогВыгрузки, ПолучитьМаскуВсеФайлы());
	юТест.Проверить(МассивФайлов.Количество() > 0, "в каталоге разложения модулей 1С <"+КаталогВыгрузки+"> должны быть файлы");
	
	Распаковщик.ВыполнитьКоммитГит(КаталогВыгрузки, "помещено из скрипта", "noreply <me@noreply.com>");

	КонецПроцедуры

Функция ОбернутьВКавычки(Знач Строка);
	Возврат """" + Строка + """";
КонецФункции

Функция ИнициализироватьТестовоеХранилищеГит(Знач КаталогРепозитория, Знач КакЧистое = Ложь)

	КодВозврата = Неопределено;
	ЗапуститьПриложение("git init" + ?(КакЧистое, " --bare", ""), КаталогРепозитория, Истина, КодВозврата);
	
	Возврат КодВозврата;
	
КонецФункции

Функция ПутьКВременномуФайлуХранилища1С()
	
	Возврат ОбъединитьПути(КаталогFixtures(), "ТестовыйФайлХранилища1С.1CD");
	
КонецФункции

Процедура СоздатьФайлАвторовГит_ДляТестов(Знач Каталог)

	ФайлАвторов = Новый ЗаписьТекста;
	ФайлАвторов.Открыть(ОбъединитьПути(Каталог, "AUTHORS"), "utf-8");
	ФайлАвторов.ЗаписатьСтроку("Администратор=Администратор <admin@localhost>");
	ФайлАвторов.ЗаписатьСтроку("Отладка=Отладка <debug@localhost>");
	ФайлАвторов.Закрыть();

КонецПроцедуры

Процедура ТестДолжен_ВыполнитьGitPush() Экспорт

	ВременныйРепо = ВыполнитьКлонированиеТестовогоРепо();
	
	СоздатьФайлАвторовГит_ДляТестов(ВременныйРепо.ЛокальныйРепозиторий);
	юТест.ПроверитьИстину(Новый Файл(ВременныйРепо.ЛокальныйРепозиторий+"\AUTHORS").Существует());
	
	Распаковщик.ВыполнитьКоммитГит(ВременныйРепо.ЛокальныйРепозиторий, "test commit", "Администратор <admin@localhost>");
	
	КодВозврата = Распаковщик.ВыполнитьGitPush(ВременныйРепо.ЛокальныйРепозиторий, ВременныйРепо.URLРепозитария, ВременныйРепо.ИмяВетки);
	юТест.ПроверитьРавенство(КодВозврата, 0, "Git должен завершиться с кодом 0");

КонецПроцедуры

Процедура ТестДолжен_ВыполнитьGitPull() Экспорт
	
	ВременныйРепо = ВыполнитьКлонированиеТестовогоРепо();
	
	СоздатьФайлАвторовГит_ДляТестов(ВременныйРепо.ЛокальныйРепозиторий);
	юТест.ПроверитьИстину(Новый Файл(ВременныйРепо.ЛокальныйРепозиторий+"\AUTHORS").Существует());
	
	Распаковщик.ВыполнитьКоммитГит(ВременныйРепо.ЛокальныйРепозиторий, "test commit", "Администратор <admin@localhost>");
	
	КодВозврата = Распаковщик.ВыполнитьGitPush(ВременныйРепо.ЛокальныйРепозиторий, ВременныйРепо.URLРепозитария, ВременныйРепо.ИмяВетки);
	юТест.ПроверитьРавенство(КодВозврата, 0, "Git должен завершиться с кодом 0");
	
	КодВозврата = Распаковщик.ВыполнитьGitPull(ВременныйРепо.ЛокальныйРепозиторий, ВременныйРепо.URLРепозитария, ВременныйРепо.ИмяВетки);
	юТест.ПроверитьРавенство(КодВозврата, 0, "Git должен завершиться с кодом 0");
	
КонецПроцедуры

Функция ВыполнитьКлонированиеТестовогоРепо()
	
	БазовыйКаталог = ВременныеФайлы.СоздатьКаталог();
	УдаленныйКаталог = ОбъединитьПути(БазовыйКаталог, "remote");
	ЛокальныйКаталог = ОбъединитьПути(БазовыйКаталог, "local");
	СоздатьКаталог(УдаленныйКаталог);
	СоздатьКаталог(ЛокальныйКаталог);
	
	URLРепозитария = УдаленныйКаталог;
	
	Лог.Отладка("Инициализация репо в каталоге " + URLРепозитария);
	Если ИнициализироватьТестовоеХранилищеГит(URLРепозитария, Истина) <> 0 Тогда
		ВызватьИсключение "Не удалось инициализировать удаленный репо";
	КонецЕсли;
	
	ИмяВетки = "master";
	
	ФайлЛога = ВременныеФайлы.СоздатьФайл("log");
	Батник = СоздатьКомандныйФайл();
	ДобавитьВКомандныйФайл(Батник, "chcp 1251 > nul");
	ДобавитьВКомандныйФайл(Батник, СтроковыеФункции.ПодставитьПараметрыВСтроку("cd /d ""%1""", ЛокальныйКаталог));
	
	ПараметрыКоманды = Новый Массив;
	ПараметрыКоманды.Добавить("git clone");
	ПараметрыКоманды.Добавить(URLРепозитария);
	ПараметрыКоманды.Добавить(ОбернутьВКавычки("%CD%"));
	ПараметрыКоманды.Добавить(СуффиксПеренаправленияВывода(ФайлЛога, Истина));
	
	КоманднаяСтрока = СобратьКоманднуюСтроку(ПараметрыКоманды);
	Лог.Отладка("Командная строка git clone:" + Символы.ПС + КоманднаяСтрока);
	ДобавитьВКомандныйФайл(Батник, КоманднаяСтрока);
	ДобавитьВКомандныйФайл(Батник, "exit /b %ERRORLEVEL%");
	
	РезультатКлонирования = ВыполнитьКомандныйФайл(Батник);
	// вывод всех сообщений от Git
	ВывестиТекстФайла(ФайлЛога);
	юТест.ПроверитьРавенство(РезультатКлонирования, 0, "git clone должен отработать успешно");
	
	Ответ = Новый Структура;
	Ответ.Вставить("ЛокальныйРепозиторий", ЛокальныйКаталог);
	Ответ.Вставить("URLРепозитария", URLРепозитария); 
	Ответ.Вставить("ИмяВетки", ИмяВетки);
	
	Возврат Ответ;
	
КонецФункции

//////////////////////////////////////////////////////////////////////////
// Работа с командными файлами

Функция СоздатьКомандныйФайл(Знач Путь = "")

	Файл = Новый КомандныйФайл();
	Файл.Открыть(Путь);
	
	Возврат Файл;
	
КонецФункции

Процедура ДобавитьВКомандныйФайл(Знач ДескрипторКомандногоФайла, Знач Команда)
	ДескрипторКомандногоФайла.Добавить(Команда);
КонецПроцедуры

Функция ВыполнитьКомандныйФайл(Знач ДескрипторКомандногоФайла)
	Возврат ДескрипторКомандногоФайла.Выполнить();
КонецФункции

Функция ЗакрытьКомандныйФайл(Знач ДескрипторКомандногоФайла)
	
	Возврат ДескрипторКомандногоФайла.Закрыть();
	
КонецФункции

Функция СуффиксПеренаправленияВывода(Знач ИмяФайлаПриемника, Знач УчитыватьStdErr = Истина)
	Возврат "> " + ИмяФайлаПриемника + ?(УчитыватьStdErr, " 2>&1", "");
КонецФункции

Функция СобратьКоманднуюСтроку(Знач ПереченьПараметров)
	
	СтрокаЗапуска = "";
	Для Каждого Параметр Из ПереченьПараметров Цикл
	
		СтрокаЗапуска = СтрокаЗапуска + " " + Параметр;
		
	КонецЦикла;
	
	Возврат СтрокаЗапуска;
	
КонецФункции

Процедура ВывестиТекстФайла(Знач ИмяФайла, Знач Кодировка = Неопределено)

	Файл = Новый Файл(ИмяФайла);
	Если НЕ Файл.Существует() Тогда
		Возврат;
	КонецЕсли;
	
	Если Кодировка = Неопределено Тогда
		Кодировка = "utf-8";
	КонецЕсли;
	
	ЧТ = Новый ЧтениеТекста(ИмяФайла, Кодировка);
	СтрокаФайла = ЧТ.Прочитать();
	ЧТ.Закрыть();
	
	Лог.Информация(СтрокаФайла);

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////

Инициализация();