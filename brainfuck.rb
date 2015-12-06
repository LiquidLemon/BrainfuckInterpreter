data = File.read(ARGV.first).gsub(/[^<>+\-,.\[\]]/, "").split("").map { |c| c.to_sym }
tape = Hash.new(0)
pointer = 0
loop_stack = Array.new
skipping_from = nil
i = 0
while true do
    op = data[i]
    
    unless skipping_from
        case op
        when :"<"
            pointer -= 1
        when :">"
            pointer += 1
        when :"+"
            tape[pointer] += 1
        when :"-"
            tape[pointer] -= 1
        when :"."
            print tape[pointer].chr        
        when :","
            tmp = STDIN.getc
            tape[pointer] = tmp.nil? ? 0 : tmp.ord
        when :"["
            loop_stack.push(i)
            skipping_from = i if tape[pointer] == 0
        when :"]"
            tmp = loop_stack.pop
            unless tape[pointer] == 0
                i = tmp
                next
            end
        end
    else
        case op
        when :"["
            loop_stack.push(i)
        when :"]"
            skipping_from = nil if loop_stack.pop == skipping_from
        end
    end 
    break if (i += 1) == data.length
end
