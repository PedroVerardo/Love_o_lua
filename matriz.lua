blocoTamanho = 30

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
    for y = 1, linhas do
        local linhaCompleta = true
        for x = 1, colunas do
            if matriz[y][x] == 0 then
                linhaCompleta = false
                break
            end
        end
        if linhaCompleta then
            removeLinhaAnimado(matriz, y, 0.5)
            move_linhas_para_baixo(matriz, y)
        end
    end
end

function remove_linha(matriz, linha_index)
    for i = 1, colunas do
        matriz[linha_index][i] = 0
    end
end


function removeLinhaAnimado(matriz, linha, tempoAnimacao)
    local tamanho = blocoTamanho
    
    for t = 1, tempoAnimacao * 60 do
        local fator = 1 - (t / (tempoAnimacao * 60)) 
        for x = 1, colunas do
            local blocoX = (x - 3) * blocoTamanho
            local blocoY = (linha - 3) * blocoTamanho
            local novoTamanho = tamanho * fator
            
            love.graphics.setColor(0,0,0,255)
            love.graphics.rectangle("fill", blocoX + (blocoTamanho - novoTamanho) / 2, blocoY + (blocoTamanho - novoTamanho) / 2, novoTamanho, novoTamanho)
        end
        
        coroutine.yield()
    end

    for x = 1, colunas do
        matriz[linha][x] = 0
    end
end