-- TODO: Transform the document using a filter, if needed
-- Define a function to insert an element between every element in a list
---@param elem_list pandoc.List
---@param insert_elem pandoc.Str
function intersperse(elem_list, insert_elem)
    local new_list = pandoc.List()
    for i, elem in ipairs(elem_list) do
        table.insert(new_list, elem)
        if i < #elem_list then
            table.insert(new_list, insert_elem)
        end
    end
    return new_list
end

-- Define a function to filter null elements from a list
---@param elem_list pandoc.List
---@param ids table<number,string>
function get_elements(elem_list, ids)
    local filtered_list = pandoc.List()
    for _, elem in ipairs(ids) do
        if elem_list[elem] ~= nil then
            filtered_list:insert(elem_list[elem])
        end
    end
    return filtered_list
end

return {
    {
        Meta = function(meta)
            for _, author in pairs(meta['by-author']) do
                if author['attributes'] and author['attributes']['equal-contributor'] then
                    meta['equal-contributor'] = true
                end
            end
            for i, affil in ipairs(meta['by-affiliation']) do
                nameline = intersperse(get_elements(affil, { "department", "name" }),
                    pandoc.Str(", "))
                addrline1 = intersperse(
                    get_elements(affil, { "address", "city", "state" }),
                    pandoc.Str(", "))
                addrline2 = intersperse(
                    get_elements(affil, { "postal-code", "country" }),
                    pandoc.Str(", "))
                addrline = intersperse(pandoc.List({ addrline1, addrline2 }):filter(function(a) return #a > 0 end),
                    pandoc.Str(" "))
                affil["lines"] = pandoc.List({nameline, addrline}):filter(function(l) return #l > 0 end)
            end
            return meta
        end
    }
}
