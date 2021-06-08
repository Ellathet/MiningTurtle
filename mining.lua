local height = 0; --Altura
local width = 0; -- Largura
local depth = 0; -- Profundidade


if #arg == 3 then
    height = tonumber(arg[1]);
    width = tonumber(arg[2]);
    depth = tonumber(arg[3]);

    if width % 2 == 0 or height % 2 == 0 then
        print("Os argumentos de Altura e Largura devem ser impares");
        return
    elseif width == 1 or height == 1 then
        print("Os argumentos de Altura e Largura devem ser maior que: 1");
        return
    end

else
    print("Por favor coloque um valor valido: Altura, Largura, Profundidade");
    return
end

local INVENTORY_SIZE = 16;
local heightMovement = math.floor(height / 2);
local widthMovement = math.floor(width / 2);

-- Lista de Combustiveis
local ACCEPTED_FUELS = {
    "minecraft:coal_block",
    "minecraft:coal";
}

-- Lista dos blocos aceitos
local ACCEPTED_ITEMS = {
    "minecraft:coal_block",
    "minecraft:coal",
    "minecraft:iron_ore",
    "minecraft:gold_ore",
    "minecraft:redstone",
    "minecraft:diamond",
    "minecraft:emerald",
    "minecraft:dye",
    "thermalfoundation:ore",
    "appliedenergistics2:material",
    "tconstruct:ore"
}

-- Check de Inventario
function inventoryCheck()
    -- Verificação de lixo
    for i = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(i);
        if currentItem ~= nil then
            local isAcceptedItem = false;
            for x = 1, #ACCEPTED_ITEMS do
                if currentItem.name == ACCEPTED_ITEMS[x] then
                    isAcceptedItem = true;
                end
            end
            if not isAcceptedItem then
                turtle.select(i);
                turtle.dropUp();
            end
        end
    end
end

-- Juntar itens

for j = 1, INVENTORY_SIZE do
    local currentItem = turtle.getItemDetail(j);

    if currentItem ~= nil then
        turtle.select(j);
        for k = j, INVENTORY_SIZE do
            if turtle.compareTo(k) then
                turtle.select(k);
                turtle.transferTo(j);
                turtle.select(j);
            end
        end
    end
end


-- Encher o Tanque
function refuel(slot_number)
    print("[TURTLE] Recarregando... ");
    turtle.select(slot_number);
    turtle.refuel();
    print("[TURTLE] Nom. Nom. Nom.");
end

-- Checar o Combustivel
function checkFuelLevel()
    local requireFuelLevel = math.ceil((height * width * depth) + (heightMovement + widthMovement));
    local currentFuelLevel = turtle.getFuelLevel(); 

    print("[TURTLE] O meu nivel de combustivel atual é: " ..currentFuelLevel.. " Eu preciso de: " ..requireFuelLevel)

    if currentFuelLevel < requireFuelLevel then
        
        print("[TURTLE] Localizando o combustivel...")

        for i = 1, INVENTORY_SIZE do
            local currentItem = turtle.getItemDetail(i);
            if currentItem ~= nil then
                for x = 1, #ACCEPTED_FUELS do
                    if currentItem.name == ACCEPTED_FUELS[x] then
                        print("[TURTLE] Combustivel aceito não encontrado " ..ACCEPTED_FUELS[x]);

                        if currentFuelLevel < requireFuelLevel then
                            refuel(i);
                        else
                            return true
                        end
                    end
                end
            end
        end
        print("[TURTLE] Não achei o combustivel ideal, estou terminando o programa...")
        return false
    else
        return true
    end
end

-- Guerra contra o Cascalho e a Areia
function moveUpAndDig()
    while turtle.up() == false do
        turtle.digUp();
    end
end

function moveForwardAndDig()
    while turtle.forward() == false do
        turtle.dig();
    end
end

function moveDownAndDig()
    while turtle.down() == false do
        turtle.digDown();
    end
end

-- Voltar para a posição inicial
function moveToStartPosition()
    
    -- Mover na horizontal para a posição inicial
    turtle.turnLeft();
    for i = 1, widthMovement do
        moveForwardAndDig();
    end
    turtle.turnRight();

    -- Mover na vertical para a posição inicial
    for i = 1, heightMovement do
        moveUpAndDig();
    end

end

-- Sequencia de Mineração
function mineSequence()

    moveToStartPosition()
    
    for x = 1, depth do
        
        moveForwardAndDig()

        for i = 1, height do

            if x % 2 == 0 then
                turtle.turnLeft();
            else
                turtle.turnRight();
            end

            for y = 1, width - 1 do
                moveForwardAndDig();
            end

        if i ~= height then

            if x % 2 == 0 then
                turtle.turnLeft();
                moveUpAndDig();
            else
                turtle.turnRight();
                moveDownAndDig();
            end
        end

        end

        if x % 2 == 0 then
            turtle.turnRight();
        else
            turtle.turnLeft();
        end

        inventoryCheck()

    end

end

if checkFuelLevel() then
    mineSequence()
end