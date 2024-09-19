cores = {
    [1] = {1, 0, 0}, --r
    [2] = {0, 1, 0}, --g
    [3] = {0, 0, 1} --b
}

pecas = {
    -- Peça I
    {
        {1, 1, 1, 1}
    },
    -- Peça O
    {
        {1, 1},
        {1, 1}
    },
    -- Peça T
    {
        {0, 1, 0},
        {1, 1, 1}
    },
    -- Peça S
    {
        {0, 1, 1},
        {1, 1, 0}
    },
    -- Peça Z
    {
        {1, 1, 0},
        {0, 1, 1}
    },
    -- Peça J
    {
        {1, 0, 0},
        {1, 1, 1}
    },
    -- Peça L
    {
        {0, 0, 1},
        {1, 1, 1}
    }
}

function gerarPecaAleatoria()
    local indice = math.random(1, #pecas)
    local pecaOriginal = pecas[indice]
    local pecaCopia = {}
    for i = 1, #pecaOriginal do
        pecaCopia[i] = {}
        for j = 1, #pecaOriginal[i] do
            pecaCopia[i][j] = pecaOriginal[i][j]
        end
    end
    return pecaCopia
end

function gerarCorAleatoria()
    local indice = math.random(1, #cores)
    return indice, cores[indice]
end

function criarNovaPeca()
    local peca = gerarPecaAleatoria()
    local corID, cor = gerarCorAleatoria()
    local posicaoX = math.floor(colunas / 2)
    local posicaoY = 1

    local novaPeca = {
        forma = peca,
        cor = cor,
        corID = corID,
        x = posicaoX,
        y = posicaoY,
        velocidade = 0.5
    }

    local function desenha(peca)
        for i = 1, #peca.forma do
            for j = 1, #peca.forma[i] do
                if peca.forma[i][j] == 1 then
                    love.graphics.setColor(peca.cor)
                    local x = (peca.x + j - 2) * blocoTamanho
                    local y = (peca.y + i - 2) * blocoTamanho
                    love.graphics.rectangle("fill", x, y, blocoTamanho, blocoTamanho)
                end
            end
        end
    end

    return {
        fixa = function (matriz)
            fixarPecaNaMatriz(matriz, novaPeca)
        end,
        draw = function ()
            desenha(novaPeca)
        end,
        move = function (dx, dy, matriz)
            if podeMover(novaPeca, dx, dy, matriz) then
                novaPeca.x = novaPeca.x + dx
                novaPeca.y = novaPeca.y + dy
                return true
            end
            return false
        end,
        podeMover = function(dx, dy, amtriz)
            return podeMover(novaPeca, dx, dy, matriz)
        end,
        update = function (dt)
            novaPeca.velocidade = novaPeca.velocidade - dt
            if novaPeca.velocidade <= 0 then
                novaPeca.velocidade = 0.5
                novaPeca.move(0, 1)
            end
            draw()
        end,
        
        rotaciona = function ()
            novaPeca.forma = rotacionarSentidoHorario(novaPeca.forma)
        end,
        x = novaPeca.x,
        y = novaPeca.y
    }
end

function podeMover(peca, dx, dy, matriz)
    for i = 1, #peca.forma do
        for j = 1, #peca.forma[i] do
            if peca.forma[i][j] == 1 then
                local novaX = peca.x + j - 1 + dx
                local novaY = peca.y + i - 1 + dy

                if novaX < 1 or novaX > colunas or novaY > linhas then
                    return false
                end
                if matriz[novaY][novaX] ~= 0 then
                    return false
                end
            end
        end
    end
    return true
end

function fixarPecaNaMatriz(matriz, peca)
    for i = 1, #peca.forma do
        for j = 1, #peca.forma[i] do
            if peca.forma[i][j] == 1 then
                local x = peca.x + j - 1
                local y = peca.y + i - 1
                matriz[y][x] = peca.corID
            end
        end
    end
end

function inverterArray(array)
    local novoArray = {}
    local tamanho = #array
    for i = 1, tamanho do
        novoArray[i] = array[tamanho - i + 1]
    end
    return novoArray
end

function rotacionarSentidoHorario(matriz)
    local linhas = #matriz
    local colunas = #matriz[1] 
    local novaMatriz = {}

   -- transposta
    for i = 1, colunas do
        novaMatriz[i] = {}
        for j = 1, linhas do
            novaMatriz[i][j] = matriz[linhas - j + 1][i]
        end
    end

    return novaMatriz
end

