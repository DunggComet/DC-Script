```lua
-- Ẩn giao diện GameGuardian ban đầu
gg.setVisible(false)
gg.setVisible(true)
--------------------------------------------------
-- Các biến toàn cục
local speed_addresses = {}
local speed_edits = {}
local speed_backup = {}
local status_speed = false
local original_value = nil

-- Hàm hack tốc độ
function ch1()
    local initOptions = {
        "🚀 Kích hoạt Speedhack",
        "🔄 Khôi phục Speedhack",
        "↩️ Quay lại"
    }
    
    local initChoice = gg.choice(initOptions, nil, "⏩ Trạng thái Speedhack: " .. (status_speed and "Đã kích hoạt 🟢" or "Chưa kích hoạt 🔴"))

    if initChoice == nil then
        gg.sleep(100)
        gg.setVisible(false)
        return
    end

    if initChoice == 3 then
        L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/VN/Khanh/Loader.lua').content
        if not L then 
            gg.alert('🌐 Máy chủ: Vui lòng bật kết nối internet...')
        else
            pcall(load(L))
        end
        return
    end

    if initChoice == 2 then
        -- Khôi phục hack tốc độ
        if #speed_backup == 0 or #speed_edits == 0 or original_value == nil then
            gg.toast("⚠️ Không đủ dữ liệu để khôi phục hack tốc độ!")
            return
        end
        gg.setValues(speed_backup)
        gg.removeListItems(speed_edits)
        speed_edits = {}
        speed_backup = {}
        speed_addresses = {}
        status_speed = false
        original_value = nil
        gg.clearResults()
        gg.toast("✅ Đã khôi phục hack tốc độ!")
        return
    end

    -- Kích hoạt hack tốc độ
    if not status_speed then
        -- Nếu chưa tìm kiếm trước đó
        if #speed_addresses == 0 then
            gg.clearResults()
            gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
            gg.searchNumber("8295", gg.TYPE_DWORD)
            local paneyoi = gg.getResults(50000)

            if #paneyoi == 0 then
                gg.clearResults()
                gg.toast("⚠️ Lỗi: Không tìm thấy kết quả!")
                return
            end

            for i = 1, #paneyoi do
                paneyoi[i].address = paneyoi[i].address + 0x60
            end

            gg.loadResults(paneyoi)
            gg.refineNumber("5", gg.TYPE_DWORD)
            local fix = gg.getResults(10000)

            if #fix == 0 then
                gg.clearResults()
                gg.toast("⚠️ Lỗi: Không tìm thấy dữ liệu!")
                return
            end

            for i = 1, #fix do
                fix[i].address = fix[i].address + 0x18
            end

            gg.loadResults(fix)

            -- Danh sách các giá trị để kiểm tra tuần tự với các giá trị khôi phục tương ứng
            local values_to_check = {
                { search = "1065353216", revert = 1.0 }, -- x1
                { search = "1073741824", revert = 1.0 }, -- x2
                { search = "1077936128", revert = 1.0 }, -- x3
                { search = "1082130432", revert = 1.0 }, -- x4
                { search = "1084227584", revert = 1.0 }, -- x5
                { search = "1086324736", revert = 1.0 }, -- x6
                { search = "1092616192", revert = 1.0 }, -- x10
                { search = "1097859072", revert = 1.0 }, -- x15
                { search = "1101004800", revert = 1.0 }, -- x20
                { search = "1103626240", revert = 1.0 } -- x25
            }

            local found = {}
            -- Thử từng giá trị một cho đến khi tìm thấy kết quả hợp lệ
            for _, entry in ipairs(values_to_check) do
                gg.clearResults()
                gg.loadResults(fix)
                gg.refineNumber(entry.search, gg.TYPE_DWORD)
                found = gg.getResults(100)

                if #found > 0 then
                    -- Kiểm tra offset -8 có giá trị 0 (xác thực)
                    local valid = {}
                    for i, v in ipairs(found) do
                        local check = {
                            { address = v.address - 0x8, flags = gg.TYPE_DWORD }
                        }
                        local checkValues = gg.getValues(check)
                        if checkValues[1].value == 0 then
                            table.insert(valid, {
                                address = v.address,
                                flags = gg.TYPE_FLOAT
                            })
                        end
                    end

                    if #valid > 0 then
                        speed_addresses = valid
                        original_value = entry.revert -- Lưu giá trị khôi phục
                        break -- Thoát vòng lặp nếu tìm thấy kết quả hợp lệ
                    end
                end
            end

            if #speed_addresses == 0 then
                gg.clearResults()
                gg.toast("⚠️ Lỗi: Không tìm thấy dữ liệu thời gian!")
                return
            end
        end

        -- Menu chọn tốc độ
        local speedOptions = {
            "⚡ Tốc độ x2",
            "⚡ Tốc độ x4",
            "⚡ Tốc độ x5",
            "⚡ Tốc độ x6",
            "⚡ Tốc độ x10",
            "⚡ Tốc độ x15",
            "⚡ Tốc độ x20",
            "⚡ Tốc độ x25",
            "↩️ Quay lại menu"
        }
        
        local speedChoice = gg.choice(speedOptions, nil, "✨ Chọn Tốc Độ:")
        
        if speedChoice == nil or speedChoice == 9 then
            return -- Quay lại menu chính
        end

        -- Đặt giá trị tốc độ dựa trên lựa chọn
        local selected = 1
        if speedChoice == 1 then
            selected = 2
        elseif speedChoice == 2 then
            selected = 4
        elseif speedChoice == 3 then
            selected = 5
        elseif speedChoice == 4 then
            selected = 6
        elseif speedChoice == 5 then
            selected = 10
        elseif speedChoice == 6 then
            selected = 15
        elseif speedChoice == 7 then
            selected = 20
        elseif speedChoice == 8 then
            selected = 25
        end

        -- Đặt giá trị mới và đóng băng
        local edits = {}
        local backup = {}
        for i, v in ipairs(speed_addresses) do
            table.insert(edits, {
                address = v.address,
                name = "Hack Tốc Độ",
                flags = gg.TYPE_FLOAT,
                value = selected,
                freeze = true
            })
            table.insert(backup, {
                address = v.address,
                flags = gg.TYPE_FLOAT,
                value = original_value, -- Khôi phục về giá trị đã ánh xạ
                freeze = false
            })
        end

        gg.setValues(edits)
        gg.addListItems(edits)

        -- Lưu vào biến toàn cục
        speed_edits = edits
        speed_backup = backup
        status_speed = true
        gg.clearResults()
        gg.toast("🎉 Hack tốc độ đã kích hoạt! Tốc độ đã thay đổi thành công thành: x" .. selected)
    else
        -- Nếu hack tốc độ đã bật, cho phép thay đổi tốc độ
        local speedOptions = {
            "⚡ Tốc độ x2",
            "⚡ Tốc độ x4",
            "⚡ Tốc độ x5",
            "⚡ Tốc độ x6",
            "⚡ Tốc độ x10",
            "⚡ Tốc độ x15",
            "⚡ Tốc độ x20",
            "⚡ Tốc độ x25",
            "↩️ Quay lại menu"
        }
        
        local speedChoice = gg.choice(speedOptions, nil, "✨ Thay Đổi Tốc Độ:")
        
        if speedChoice == nil or speedChoice == 9 then
            return -- Quay lại menu chính
        end

        local selected = 1
        if speedChoice == 1 then
            selected = 2
        elseif speedChoice == 2 then
            selected = 4
        elseif speedChoice == 3 then
            selected = 5
        elseif speedChoice == 4 then
            selected = 6
        elseif speedChoice == 5 then
            selected = 10
        elseif speedChoice == 6 then
            selected = 15
        elseif speedChoice == 7 then
            selected = 20
        elseif speedChoice == 8 then
            selected = 25
        end

        local edits = {}
        for i, v in ipairs(speed_addresses) do
            table.insert(edits, {
                address = v.address,
                name = "Hack Tốc Độ",
                flags = gg.TYPE_FLOAT,
                value = selected,
                freeze = true
            })
        end

        gg.setValues(edits)
        gg.addListItems(edits)
        speed_edits = edits
        gg.clearResults()
        gg.toast("⚡ Speed đã cập nhật! Tốc độ đã thay đổi thành công thành: x" .. selected)
    end
end

-- Vòng lặp chính
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        ch1()
    end
end
```
