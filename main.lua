colunas = 10
linhas = 20

math.randomseed(os.time())
require "pecas"
require "matriz"

blocoTamanho = 30
local pecaAtual
local tempo = 0
local velocidade = 0.5
local board
local co
local animation = false

function love.load()
    board = inicializa_board()
    pecaAtual = criarNovaPeca()
    love.window.setMode(colunas * blocoTamanho, linhas * blocoTamanho)

    co = coroutine.create(verificarLinhasCompletas)
end

function love.update(dt)
    if gameOver then
        return -- stop the game from updating when game over
    end

    -- Handle the piece movement and line completion checks
    tempo = tempo + dt
    if tempo >= velocidade then
        tempo = 0

        if pecaAtual.move(0, 1, board) then
            print("Pode mover")
        else
            pecaAtual.fixa(board)
            local linhasRemovidas = verificarLinhasCompletas(board)

            -- If lines are being removed, start animation
            if linhasRemovidas then
                animation = true
            end

            verificarPerdeuJogo(board)
            pecaAtual = criarNovaPeca()
        end
    end

    -- Check if an animation is in progress
    if animatingLine then
        animatingTime = animatingTime - dt

        -- When the animation is done, clear the line and stop the animation
        if animatingTime <= 0 then
            move_linhas_para_baixo(board, animatingLine)
            animatingLine = nil
            animation = false
        end
    end
end

function love.draw()
    -- If the game is over, show only the "Game Over" message
    if gameOver then
        love.graphics.clear(0, 0, 0) -- Clear the screen (black background)

        -- Set font size and color
        love.graphics.setColor(1, 0, 0)
        love.graphics.setNewFont(48) -- Increase font size
        love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 2 - 24, love.graphics.getWidth(), "center")

        return -- Skip the rest of the drawing
    end

    -- Draw the board with pieces if the game is not over
    for y = 1, linhas do
        for x = 1, colunas do
            if board[y][x] ~= 0 then
                love.graphics.setColor(cores[board[y][x]])
                love.graphics.rectangle("fill", (x - 1) * blocoTamanho, (y - 1) * blocoTamanho, blocoTamanho, blocoTamanho)
            end
        end
    end

    -- Draw the current falling piece
    pecaAtual.draw()

    -- Animate the shrinking of the line if animation is in progress
    if animatingLine then
        local shrinkFactor = animatingTime / animationDuration -- Scale the shrinking over time
        love.graphics.setColor(1, 0, 0) -- You can change this color if you like
        for x = 1, colunas do
            local blocoX = (x - 1) * blocoTamanho
            local blocoY = (animatingLine - 1) * blocoTamanho
            local novoTamanho = blocoTamanho * shrinkFactor
            love.graphics.rectangle("fill", blocoX + (blocoTamanho - novoTamanho) / 2, blocoY + (blocoTamanho - novoTamanho) / 2, novoTamanho, novoTamanho)
        end
    end
end


function love.keypressed(key)
    if key == "left" then
        pecaAtual.move(-1, 0, board)
    elseif key == "right" then
        pecaAtual.move(1, 0, board)
    elseif key == "down" then
        pecaAtual.move(0, 1, board)
    elseif key == "up" then
        pecaAtual.rotaciona()
    end
end

function love.quit()
    os.exit()
end
