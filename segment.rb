# 给数组array,为了能够方便的得到区间的sum，使用线段树结构。线段树内部节点存sum
array = [1,3,5,7,9,11]
# 用tree来存线段树。
tree = []
def build(node, start, tail, array, tree)
  # 判断是否是叶节点，然后把数组array的元素存入线段树的叶节点。
  if start == tail
    tree[node] = array[start]
  else
    mid = (start + tail)/2.to_i
    # 建立左儿子和右儿子
    build(2*node, start, mid, array, tree)
    build(2*node + 1, mid + 1, tail, array, tree)
    # 递归的回归过程中（bottom_up）,计算内节点的值
    tree[node] = tree[2*node] + tree[2*node +1]
  end
end

def update(node, start, tail, idx, val, tree)
  if start == tail
    tree[node] = val
    return
  end
  # 判断idx在左子树还算右子树
  mid = (start + tail)/2.to_i
  if start <= idx && idx <= mid
    update(2*node, start, mid, idx, val, tree)
  else
    update(2*node + 1, mid+1, tail, idx, val, tree)
  end
  tree[node] = tree[2*node] + tree[2*node +1]
end

# node为当前查找的节点的在线段树的索引
# queryL, 用户查找的左边界
# queryR, 用户查找的右边界
def query(node, start, tail, queryL, queryR, tree)
  # 不相交，返回0
  if queryR < start || tail < queryL
    return 0
  # 查询范围包含（或完全重合）了当前节点的范围。
  elsif queryL <= start && tail <= queryR
    return tree[node]
  else
  #其他情况：部分相交和要查询范围在节点范围内（但不重合）的情况，递归：
    mid = (start + tail)/2.to_i
    p1 = query(2*node, start, mid, queryL, queryR, tree)
    p2 = query(2*node + 1, mid + 1, tail, queryL, queryR,  tree)
    return p1 + p2
  end
end

build(1, 0, array.size - 1 , array, tree)
p tree
#结果是：
# [nil, 36, 9, 27, 4, 5, 16, 11, 1, 3, nil, nil, 7, 9]
# 更新array的元素 array[1] == 2
array[1] = 2
# 更新线段树
update(1, 0, array.size - 1, 1, 2, tree)
p tree
#结果： [nil, 35, 8, 27, 3, 5, 16, 11, 1, 2, nil, nil, 7, 9]
# tree[9] 即array[1]
p query(1, 0, array.size - 1, 2, 5,tree)
# 结果32
