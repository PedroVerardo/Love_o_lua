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
    tempo = tempo + dt
    if tempo >= velocidade then
        tempo = 0

        if pecaAtual.move(0, 1, board) then
            print("Pode mover")
        if animation then
            status = coroutine.resume(co, board)
        end
        else
            animation = true
            pecaAtual.fixa(board)
            --verificarLinhasCompletas(board)
            status = coroutine.resume(co, board)
            pecaAtual = criarNovaPeca()
        end
    end
end

function love.draw()
    for y = 1, linhas do
        for x = 1, colunas do
            if board[y][x] ~= 0 then
                love.graphics.setColor(cores[board[y][x]])
                love.graphics.rectangle("fill", (x - 1) * blocoTamanho, (y - 1) * blocoTamanho, blocoTamanho, blocoTamanho)
            end
        end
    end

    pecaAtual.draw()
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
