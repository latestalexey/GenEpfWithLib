#Использовать cmdline
#Использовать logos
#Использовать tempfiles

Перем Лог;
Перем ИсходнаяОбработка;
Перем КаталогБиблиотек;
Перем КаталогНовойОбработки;
Перем РабочийКаталог;

Перем КодВозврата;

Процедура Инициализация()
	Лог = Логирование.ПолучитьЛог("oscript.app.MakeMagic");
	Лог.Закрыть();

	ВыводПоУмолчанию = Новый ВыводЛогаВКонсоль();
	Лог.ДобавитьСпособВывода(ВыводПоУмолчанию);
КонецПроцедуры

Функция ПрочитатьАргументыКоманднойСтроки()
	Если АргументыКоманднойСтроки.Количество() <> 3 Тогда
		Лог.Ошибка("Переданы некорректные параметры командной строки! Параметров должно быть 3");
		Возврат Ложь;
	КонецЕсли;
	
	ИсходнаяОбработка		= АргументыКоманднойСтроки[0];
	КаталогБиблиотек		= АргументыКоманднойСтроки[1];
	КаталогНовойОбработки	= АргументыКоманднойСтроки[2];

	//Здесь могут быть проверки аргументов

	Возврат Истина;
КонецФункции

Функция РазобратьВнешнуюОбработку()
	Файл = Новый Файл(ИсходнаяОбработка);
	КопироватьФайл(ИсходнаяОбработка, ОбъединитьПути(РабочийКаталог, Файл.Имя));
	ЗапуститьПриложение("precommit1c --decompile ./" + Файл.Имя, РабочийКаталог, Истина, КодВозврата);
	Возврат (КодВозврата = 0);
КонецФункции

Функция ДополнитьФайлМодуляОбъекта()
	Файл = Новый Файл(ИсходнаяОбработка);

	
	ПутьКМодулюОбъекта = ОбъединитьПути(РабочийКаталог, Файл.ИмяБезРасширения, "ObjectModule.bsl");
	ФайлМодуля = Новый Файл(ПутьКМодулюОбъекта);
	ТекстМодуля = "";
	Если ФайлМодуля.Существует() Тогда
		Лог.Информация("Модуль объекта уже существует");
		Чтение = Новый ЧтениеТекста(ПутьКМодулюОбъекта);
		ТекстМодуля = Чтение.Прочитать();
		Чтение.Закрыть();
	Иначе
		Лог.Информация("Модуль объекта нет");
	КонецЕсли;

	//Читаем файлы из библиотеки
	МассивБиблиотек = НайтиФайлы(КаталогБиблиотек, "ObjectModule.bsl", Истина);
	Для Каждого ФайлБиблиотеки из МассивБиблиотек Цикл
		Чтение = Новый ЧтениеТекста(ФайлБиблиотеки);
		ТекстБиблиотеки = Чтение.Прочитать();
	КонецЦикла

	Возврат Истина;
КонецФункции


КодВозврата = 0;
Инициализация();

Если НЕ ПрочитатьАргументыКоманднойСтроки() Тогда
	ЗавершитьРаботу(КодВозврата);
КонецЕсли;

РабочийКаталог = ВременныеФайлы.СоздатьКаталог();
Лог.Информация(РабочийКаталог);
Если НЕ РазобратьВнешнуюОбработку() ИЛИ
	НЕ ДополнитьФайлМодуляОбъекта() Тогда
	ЗавершитьРаботу(КодВозврата);
КонецЕсли;

ВременныеФайлы.Удалить();



