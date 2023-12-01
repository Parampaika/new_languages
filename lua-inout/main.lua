local file = io.open("data.txt", "r")
local resultFile = io.open("result.txt", "a")


if file and resultFile then
    local content = file:read("*all") 

    -- Заменим всю пунктуацию на пробелы
    content = content:gsub("[%p%c%s]", " ")

    -- Разделяем текст на отдельные слова и сохраняем в таблицу words
    local words = {}
    for word in content:gmatch("%S+") do
        table.insert(words, string.lower(word))
    end

    print("Введите слово для поиска:")
    local searchWord = io.read()
    searchWord = string.lower(searchWord)

    local count = 0
    for _, word in ipairs(words) do
        if word == searchWord then
            count = count + 1
        end
    end

    print("Количество повторений слова \"" .. searchWord .. "\": " .. count)

    -- Запись в файл
    resultFile:write("Количество повторений слова \"" .. searchWord .. "\": " .. count .. "\n")
  
    file:close()
    resultFile:close()
else
    print("Не удалось открыть файл")
end