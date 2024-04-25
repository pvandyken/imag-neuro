-- TODO: Transform the document using a filter, if needed
return {
    {
      Meta = function(meta)
        for _, author in pairs(meta['by-author']) do
            if author['attributes']['equal-contributor'] then
                meta['equal-contributor'] = true
            end
        end
        return meta
      end
    }
  }