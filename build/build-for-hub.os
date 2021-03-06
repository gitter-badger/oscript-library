﻿
КаталогИсходников = Новый Файл("../src");

ФайлыКаталога = НайтиФайлы(КаталогИсходников.ПолноеИмя, ПолучитьМаскуВсеФайлы());

СИ = Новый СистемнаяИнформация;
ЭтоWindows = Найти(СИ.ВерсияОС, "Windows") > 0;

Для Каждого Файл Из ФайлыКаталога Цикл
	
	Если Файл.ЭтоКаталог() Тогда
		
		ВыходнойКаталог = ОбъединитьПути(ТекущийКаталог(), "output", Файл.Имя);
		СоздатьКаталог(ВыходнойКаталог);
		
		Если ЭтоWindows Тогда
			Процесс = СоздатьПроцесс("opm.bat build " + Файл.ПолноеИмя + " -out " + ВыходнойКаталог,,Истина);
			Процесс.Запустить();
			Процесс.ОжидатьЗавершения();
			Вывод = Процесс.ПотокВывода.Прочитать();
			Сообщить(Вывод);
		Иначе
			Процесс = СоздатьПроцесс("/bin/sh opm build " + Файл.ПолноеИмя + " -out " + ВыходнойКаталог,,Истина);
			Процесс.Запустить();
			Процесс.ОжидатьЗавершения();
		КонецЕсли;
		
		Если Процесс.КодВозврата <> 0 Тогда
			УдалитьФайлы(ВыходнойКаталог);
		КонецЕсли;
		
		ОсвободитьОбъект(Процесс);
		
	КонецЕсли;
	
КонецЦикла;
