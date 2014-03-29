require './address'
require 'tree'


class TX_Tree

  def initialize(seed_address, start_time=0, min_amount=0, max_depth=1, verbose=false)
    # Set up the tree
    puts "Initializing tree... " if verbose
    puts "Starting address: #{seed_address}" if verbose
    puts "Start time: #{start_time}" if verbose
    puts "Minimum amount: #{min_amount}" if verbose
    puts "Maximum Depth: #{max_depth}" if verbose
    @seed = Address.new(seed_address)
    @root = Tree::TreeNode.new(@seed.address, 0)
    puts "Done initializing" if verbose

    # Iteratively construct tree
    puts "Constructing tree. This could take a while... " if verbose
    construct(@seed, @root, start_time, min_amount, max_depth, 0, verbose)
    puts "Done constructing" if verbose
  end

  def construct(parent_address, parent_node, time, min_amount, max_depth, depth, verbose)
    if depth <= max_depth
      puts "Depth: #{depth}; Parent: #{parent_address.address}" if verbose
      # Get all children
      children = []
      parent_address.txs_since(time).each do |tx|
        tx['out'].each do |out|
          if out['addr'] != @seed.address && out['value']/100000000.0 >= min_amount
            puts "  + #{out['addr']}" if verbose
            child = {
              :addr => Address.new(out['addr']),
              :node => Tree::TreeNode.new(out['addr'], out['value']),
              :time => tx['time']
            }
            children << child
          end
        end
      end

      # For each child, add it to the tree, and recurse to its children
      children.each do |child|
        parent_node << child[:node]
        construct(child[:addr], child[:node], child[:time], min_amount, max_depth, depth+1, verbose)
      end
    end
  end

  def display
    print_tree(@root)
  end

  def print_tree(node, level = 0)
    if node.is_root?
      print "*"
    else
      print "|" unless node.parent.is_last_sibling?
      print(' ' * (level - 1) * 4)
      print(node.is_last_sibling? ? "+" : "|")
      print "---"
      print(node.has_children? ? "+" : ">")
    end

    puts " #{node.name} : #{node.content/100000000.0}"

    node.children { |child| print_tree(child, level + 1) if child } # Child might be 'nil'
  end


end
