local transf = require "transf"
local vec3 = require "vec3"
local plan = require "snowball_forester_planner"

local forester = {}

forester.markerStore = nil
forester.finisherStore = nil
forester.lastMarker = nil
forester.markerId = "asset/snowball_forester_marker.mdl"
forester.finisherId = "asset/snowball_forester_finisher.mdl"
forester.zoneId = nil

function forester.getObjects()
    if not forester.markerStore then
        forester.markerStore = {}
    end
    if not forester.finisherStore then
        forester.finisherStore = {}
    end

    plan.updateEntityLists(forester.markerId, forester.markerStore, forester.finisherId, forester.finisherStore)    
end

function forester.removeZone()
    if forester.zoneId then
        game.interface.bulldoze(forester.zoneId)
        forester.zoneId = nil
    end
end

function forester.updateZone(outline, type)
    if forester.zoneId then
        forester.zoneId = game.interface.updateConstruction(forester.zoneId, "asset/snowball_forester_preview.con", {outline = outline, type = type}) 
    else
        forester.zoneId = game.interface.buildConstruction("asset/snowball_forester_preview.con",
            {outline = outline, type = type},
            {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
        )
    end
end

function forester.intersects(line1, line2)
    local v1x1 = line1[1][1]
    local v1y1 = line1[1][2]
    local v1x2 = line1[2][1]
    local v1y2 = line1[2][2]

    local v2x1 = line2[1][1]
    local v2y1 = line2[1][2]
    local v2x2 = line2[2][1]
    local v2y2 = line2[2][2]

    local d1, d2
    local a1, a2, b1, b2, c1, c2

    a1 = v1y2 - v1y1
    b1 = v1x1 - v1x2
    c1 = (v1x2 * v1y1) - (v1x1 * v1y2)

    d1 = (a1 * v2x1) + (b1 * v2y1) + c1
    d2 = (a1 * v2x2) + (b1 * v2y2) + c1

    if d1 > 0 and d2 > 0 then
        return false
    end

    if d1 < 0 and d2 < 0 then
        return false
    end

    a2 = v2y2 - v2y1
    b2 = v2x1 - v2x2
    c2 = (v2x2 * v2y1) - (v2x1 * v2y2)

    d1 = (a2 * v1x1) + (b2 * v1y1) + c2
    d2 = (a2 * v1x2) + (b2 * v1y2) + c2

    if d1 > 0 and d2 > 0 then
        return false
    end

    if d1 < 0 and d2 < 0 then
        return false
    end

    --colinear
    if (a1 * b2) - (a2 * b1) == 0.0 then
        return false
    end

    return true
end

function forester.getPolygon()
    local polygon = {}

    for i = 1, #forester.markerStore do
        local marker = forester.markerStore[i]
        polygon[#polygon + 1] = {marker.position[1], marker.position[2]}
    end

    if #polygon > 0 then
        return polygon
    else
        return nil
    end
end

function forester.getBounds(polygon)
    local xmin, xmax, ymin, ymax

    for i = 1, #polygon do
        local point = polygon[i]

        if (not xmin or point[1] < xmin) then
            xmin = point[1]
        end

        if (not xmax or point[1] > xmax) then
            xmax = point[1]
        end

        if (not ymin or point[2] < ymin) then
            ymin = point[2]
        end

        if (not ymax or point[2] > ymax) then
            ymax = point[2]
        end
    end

    return {
        x = xmin,
        y = ymin,
        width = xmax - xmin,
        height = ymax - ymin
    }
end

function forester.isInPolygon(point, polygon, bounds)
    local intersections = 0

    --outside of bounding box
    if
        (point[1] < bounds.x or point[1] > bounds.x + bounds.width or point[2] < bounds.y or
            point[2] > bounds.y + bounds.height)
     then
        return false
    end

    local horizontal = {{bounds.x, point[2]}, {point[1], point[2]}}

    for i = 1, #polygon do
        local j = i + 1
        if j > #polygon then
            j = 1
        end

        local line = {polygon[i], polygon[j]}

        if (forester.intersects(horizontal, line)) then
            intersections = intersections + 1
        end
    end

    return intersections % 2 == 1
end

function forester.plan(result)
    forester.getObjects()

    for i = 1, #forester.finisherStore do
        local finisher = forester.finisherStore[i]
        game.interface.bulldoze(finisher.id)
    end

    forester.finisherStore = {}

    for i = 1, #forester.markerStore + 1 do
        result.models[#result.models + 1] = {
            id = forester.markerId,
            transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
        }
    end

    local poly = forester.getPolygon(forester.markerStore)
    local color = {0, 0.8, 0, 1}

    if poly then
        if #poly == 1 then            
            local plantzone = {
                polygon = {{poly[1][1] - 5, poly[1][2], poly[1][3]}, {poly[1][1] + 5, poly[1][2], poly[1][3]}},
                draw = true,
                drawColor = color
            }
            game.interface.setZone("plantzone", plantzone)       
        else           
           local plantzone = {polygon = poly, draw = true, drawColor = color}
            game.interface.setZone("plantzone", plantzone)
        end
    end
end

function forester.reset(result)
    result.models[#result.models + 1] = {
        id = forester.finisherId,
        transf = {0.01, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 1}
    }

    game.interface.setZone("plantzone", nil)

    if not forester.markerStore then
        return
    end

    for i = 1, #forester.markerStore do
        local marker = forester.markerStore[i]
        game.interface.bulldoze(marker.id)
    end

    forester.markerStore = {}
end

function forester.plant(result, density, type)
    local tile_size = density * 2

    result.models[#result.models + 1] = {
        id = forester.finisherId,
        transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
    }

    if not forester.markerStore then
        return
    end

    local plantpoly = forester.getPolygon()    
    game.interface.setZone("plantzone", nil)

    for i = 1, #forester.markerStore do
        local marker = forester.markerStore[i]
        game.interface.bulldoze(marker.id)
    end

    forester.markerStore = {}

    if (not plantpoly) or (#plantpoly < 3) then
        return result
    end

    local bounds = forester.getBounds(plantpoly)
    local treeDensity = 1.0 / density

    local area = bounds.width * bounds.height
    if not area or area < 1e-6 then
        return result
    end

    local numTrees = math.max(1, math.floor(treeDensity * area))
    local transforms = {}

    for k = 1, numTrees do
        local x = math.random() * bounds.width + bounds.x
        local y = math.random() * bounds.height + bounds.y

        local plant = forester.isInPolygon({x, y}, plantpoly, bounds)

        if plant then
            local height = game.interface.getHeight({x, y})
            if (height >= 100) then
                local transform = transf.rotZTransl(math.random() * math.pi * 2.0, vec3.new(x, y, height))

                local cellx = tostring(math.floor(x / tile_size - bounds.x))
                local celly = tostring(math.floor(y / tile_size - bounds.y))

                if not transforms[cellx] then
                    transforms[cellx] = {}
                end

                if not transforms[cellx][celly] then
                    transforms[cellx][celly] = {}
                end

                transforms[cellx][celly][#(transforms[cellx][celly]) + 1] = transform
            end
        end
    end

    for x, transformsx in pairs(transforms) do
        for y, transformsy in pairs(transformsx) do
            game.interface.buildConstruction(
                "asset/snowball_forester_tree_patch.con",
                {transforms = transformsy, type = type},
                {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, -0.15, 1}
            )
        end
    end
end

return forester
