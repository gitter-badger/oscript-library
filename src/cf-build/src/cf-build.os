﻿
#Использовать cmdline
#Использовать logos
#Использовать v8runner
#Использовать tempfiles

Перем Лог;

Процедура Инициализация()
	
	Лог = Логирование.ПолучитьЛог("oscript.app.cf-build");
	
КонецПроцедуры

Процедура Запуск()
	
	Аргументы = РазобратьПараметрыКоманднойСтроки();
	
	Если ТипЗнч(Аргументы) = Тип("Структура") Тогда
	
		Если Аргументы.Команда = "-decompile" Тогда
			Лог.Информация("Начинаю распаковку конфигурации");
			ВыгрузитьМодулиКонфигурации(Аргументы.ЗначенияПараметров["ФайлКонфигурации"], Аргументы.ЗначенияПараметров["КаталогВыгрузки"]);
			Лог.Информация("Распаковка завершена");
		КонецЕсли;
		
	Иначе
		Лог.Информация("Начинаю сборку конфигурации");
		СобратьКонфигурацию(Аргументы["КаталогИсходников"], Аргументы["ВыходнойФайл"]);
		Лог.Информация("Сборка завершена");
	КонецЕсли;
	
КонецПроцедуры

Функция РазобратьПараметрыКоманднойСтроки()

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	
	Команда = Парсер.ОписаниеКоманды("-decompile");
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ФайлКонфигурации");
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "КаталогВыгрузки");
	Парсер.ДобавитьКоманду(Команда);
	
	Парсер.ДобавитьПараметр("КаталогИсходников");
	Парсер.ДобавитьПараметр("ВыходнойФайл");
	
	Возврат Парсер.Разобрать(АргументыКоманднойСтроки);

КонецФункции

// Выполняет штатную выгрузку конфигурации в файлы (средствами платформы 8.3)
//
Процедура ВыгрузитьМодулиКонфигурации(Знач ФайлКонфигурации, Знач КаталогВыгрузки)
	
	Конфигуратор = ПолучитьМенеджерКонфигуратора();
	Конфигуратор.ИспользоватьВерсиюПлатформы("8.3");
	
	Конфигуратор.ЗагрузитьКонфигурациюИзФайла(ФайлКонфигурации, Ложь);
	
	Если Не (Новый Файл(КаталогВыгрузки).Существует()) Тогда
		СоздатьКаталог(КаталогВыгрузки);
	КонецЕсли;
	
	МассивФайлов = НайтиФайлы(КаталогВыгрузки, ПолучитьМаскуВсеФайлы());
	Если МассивФайлов.Количество() <> 0 Тогда
		ВызватьИсключение "В каталоге <"+КаталогВыгрузки+"> не должно быть файлов";
	КонецЕсли;
	
	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/Visible");
	ПараметрыЗапуска.Добавить("/DumpConfigToFiles""" + КаталогВыгрузки + """");
	
	ВыполнитьКомандуКонфигуратора(Конфигуратор, ПараметрыЗапуска);
	
КонецПроцедуры

Функция ПолучитьМенеджерКонфигуратора()
	Конфигуратор = Новый УправлениеКонфигуратором;
	Логирование.ПолучитьЛог("oscript.lib.v8runner").УстановитьУровень(Лог.Уровень());
	КаталогСборки = ВременныеФайлы.СоздатьКаталог();
	Конфигуратор.КаталогСборки(КаталогСборки);
	Возврат Конфигуратор;
КонецФункции

Процедура ВыполнитьКомандуКонфигуратора(Знач Конфигуратор, Знач ПараметрыЗапуска)
	
	Попытка
		Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);
	Исключение
		ВременныеФайлы.УдалитьФайл(Конфигуратор.КаталогСборки());
		ВызватьИсключение;
	КонецПопытки;
	
	ВременныеФайлы.УдалитьФайл(Конфигуратор.КаталогСборки());
	
КонецПроцедуры

// Штатная сборка конфигурации
//
Процедура СобратьКонфигурацию(Знач КаталогИсходников, Знач ВыходнойФайл)
	
	Конфигуратор = ПолучитьМенеджерКонфигуратора();
	
	Попытка
		Лог.Информация("Загружаю файлы конфигурации");
		ЗагрузитьКонфигурациюИзФайлов(Конфигуратор, КаталогИсходников);
		Лог.Информация("Выгружаю CF");
		ВыгрузитьКонфигурациюВФайл(Конфигуратор, ВыходнойФайл);
	Исключение
		ВременныеФайлы.УдалитьФайл(Конфигуратор.КаталогСборки());
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗагрузитьКонфигурациюИзФайлов(Знач Конфигуратор, Знач КаталогИсходников)
	
	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/Visible");
	ПараметрыЗапуска.Добавить("/LoadConfigFromFiles""" + КаталогИсходников + """");
	
	Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ВыгрузитьКонфигурациюВФайл(Знач Конфигуратор, Знач ВыходнойФайл)
	
	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/Visible");
	ПараметрыЗапуска.Добавить("/DumpCfg """ + ВыходнойФайл + """");
	
	Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);
	
КонецПроцедуры

/////////////////////////////////////////////////////////////

Инициализация();

Попытка
	Запуск();
Исключение
	Лог.Ошибка(ИнформацияОбОшибке().Описание);
	ЗавершитьРаботу(1);
КонецПопытки;