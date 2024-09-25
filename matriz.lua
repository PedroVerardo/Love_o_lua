blocoTamanho = 30
gameOver = false


function inicializa_board()
    local matriz = {}

    for i = 1, linhas do
        matriz[i] = {}
        for j = 1, colunas do
            matriz[i][j] = 0
        end
    end

    return matriz
end

function move_linhas_para_baixo(matriz, linhaRemovida)
    for y = linhaRemovida, 2, -1 do
        matriz[y] = matriz[y - 1]
    end
    matriz[1] = {}
    for x = 1, colunas do
        matriz[1][x] = 0
    end
end

function verificarLinhasCompletas(matriz)
    local linhasRemovidas = false
    for y = 1, linhas do
        local linhaCompleta = true
        for x = 1, colunas do
            if matriz[y][x] == 0 then
                linhaCompleta = false
                break
            end
        end
        if linhaCompleta then
            linhasRemovidas = true
            co = coroutine.create(function()
                removeLinhaAnimado(matriz, y, 0.5)
                move_linhas_para_baixo(matriz, y)
            end)
            coroutine.resume(co)
        end
    end
    return linhasRemovidas
end


function verificarPerdeuJogo(matriz)
    for x = 1, colunas do
        if matriz[1][x] ~= 0 then
            gameOver = true
            return true
        end
    end
    return false
end

animatingLine = nil
animatingTime = 0
animationDuration = 0.5 -- Set the total duration for the animation

function removeLinhaAnimado(matriz, linha, tempoAnimacao)
    animatingLine = linha
    animatingTime = tempoAnimacao
end

function updateAnimation(dt)
    if animatingLine then
        animatingTime = animatingTime - dt
        if animatingTime <= 0 then
            animatingLine = nil
        end
    end
end
