# autograd

- [autograd](#autograd)
  - [Reference](#reference)
  - [Reverse accumulation exercise](#reverse-accumulation-exercise)
  - [`torch.autograd.Function` exercise](#torchautogradfunction-exercise)
  - [Q\&A](#qa)
    - [什么情况下继承了torch.autograd.Function类的forward函数会有多个返回值](#什么情况下继承了torchautogradfunction类的forward函数会有多个返回值)
  - [Example](#example)
    - [Example 1](#example-1)

## Reference

[Automatic Differentiation with torch.autograd](https://pytorch.org/tutorials/beginner/basics/autogradqs_tutorial.html)

[PyTorch: Defining New autograd Functions](https://pytorch.org/tutorials/beginner/examples_autograd/two_layer_net_custom_function.html)

[Autograd mechanics](https://pytorch.org/docs/stable/notes/autograd.html)

[PyTorch Autograd](https://towardsdatascience.com/pytorch-autograd-understanding-the-heart-of-pytorchs-magic-2686cd94ec95)

[Automatic differentiation package - torch.autograd](https://typeoverflow.com/developer/docs/pytorch/autograd)

[Graphs, Automatic Differentiation and Autograd in PyTorch](https://www.geeksforgeeks.org/graphs-automatic-differentiation-and-autograd-in-pytorch/)

[Autograd in PyTorch — How to Apply it on a Customised Function](https://medium.com/codex/autograd-in-pytorch-how-to-apply-it-on-a-customised-function-4f0033430755)

[PyTorch: Defining new autograd functions](https://sebarnold.net/tutorials/beginner/examples_autograd/two_layer_net_custom_function.html)

[Understanding Autograd: 5 Pytorch tensor functions](https://medium.com/@namanphy/understanding-autograd-5-pytorch-tensor-functions-8f47c27dc38)

[A Gentle Introduction to torch.autograd](https://pytorch.org/tutorials/beginner/blitz/autograd_tutorial.html)

[The Fundamentals of Autograd](https://pytorch.org/tutorials/beginner/introyt/autogradyt_tutorial.html)

[PyTorch: Defining New autograd Functions](https://pytorch.org/tutorials/beginner/examples_autograd/two_layer_net_custom_function.html)

## Reverse accumulation exercise

Reference [Wikipedia: Automatic differentiation - Reverse accumulation](https://en.wikipedia.org/wiki/Automatic_differentiation#Reverse_accumulation)

    class Variable:
        def __init__(self, value):
            self.value = value
            self.partial = 0
            
        def evaluate(self):
            return self.value
        
        def derive(self, seed):
            self.partial += seed
    
    class Multiply:
        def __init__(self, lhs, rhs):
            self.lhs = lhs
            self.rhs = rhs
        
        def evaluate(self):
            self.value = self.lhs.evaluate() * self.rhs.evaluate()
            return self.value
            
        def derive(self, seed):
            self.lhs.derive(seed * self.rhs.value)
            self.rhs.derive(seed * self.lhs.value)
            
    class Plus:
        def __init__(self, lhs, rhs):
            self.lhs = lhs
            self.rhs = rhs
        
        def evaluate(self):
            self.value = self.lhs.evaluate() + self.rhs.evaluate()
            return self.value
            
        def derive(self, seed):
            self.lhs.derive(seed)
            self.rhs.derive(seed)
            
    class Minus:
        def __init__(self, lhs, rhs):
            self.lhs = lhs
            self.rhs = rhs
        
        def evaluate(self):
            self.value = self.lhs.evaluate() - self.rhs.evaluate()
            return self.value
            
        def derive(self, seed):
            self.lhs.derive(seed)
            self.rhs.derive(-seed)
    
    x = Variable(3)
    y = Variable(2)
    xx = Multiply(x, x)
    xy = Multiply(x, y)
    func = Multiply(y, Plus(Minus(xx, xy), y))  # y(x^2 - xy +y)
    func_value = func.evaluate()
    print(f'func value: {func_value}')
    func.derive(1)
    print(f'partial x: {x.partial}')
    print(f'partial y: {y.partial}')
    
output:
    
    func value: 10
    partial x: 8
    partial y: 1

## `torch.autograd.Function` exercise

    import torch
    
    class Multiply(torch.autograd.Function):
        @staticmethod
        def forward(ctx, lhs, rhs):
            ctx.save_for_backward(lhs, rhs)
            return lhs * rhs
        
        @staticmethod
        def backward(ctx, grad_output):
            lhs, rhs = ctx.saved_tensors
            
            return grad_output * rhs, grad_output * lhs
        
    class Plus(torch.autograd.Function):
        @staticmethod
        def forward(ctx, lhs, rhs):
            return lhs + rhs
        
        @staticmethod
        def backward(ctx, grad_output):
            return grad_output, grad_output
        
    class Minus(torch.autograd.Function):
        @staticmethod
        def forward(ctx, lhs, rhs):
            return lhs - rhs
        
        @staticmethod
        def backward(ctx, grad_output):
            return grad_output, -grad_output
    
    x = torch.tensor([3, 3], dtype=torch.float, requires_grad=True)
    y = torch.tensor([2, 2], dtype=torch.float, requires_grad=True)
    xx = Multiply.apply(x, x)
    xy = Multiply.apply(x, y)
    func = Multiply.apply(y, Plus.apply(Minus.apply(xx, xy), y))  # y(x^2 - xy +y)
    print(f'func value: {func}')
    func.backward(torch.tensor([1, 1], dtype=torch.float), retain_graph=False)
    print(f'partial x: {x.grad}')
    print(f'partial y: {y.grad}')
    
output:
    
    func value: tensor([10., 10.], grad_fn=<MultiplyBackward>)
    partial x: tensor([8., 8.])
    partial y: tensor([1., 1.])

## Q&A

### 什么情况下继承了torch.autograd.Function类的forward函数会有多个返回值

在 PyTorch 中，继承自 `torch.autograd.Function` 的子类的 `forward` 函数可以有多个返回值，如果你的自定义操作（function）计算出了多个结果，并且你需要在后向传播中使用这些结果。

当你在计算图中执行一个操作时，这个操作可能会产生多个输出。例如，如果你正在编写一个自定义层，这一层对输入执行了两种不同的计算并输出两个张量，那么你的 `forward` 函数将会返回这两个张量。

此外，在计算梯度时，每个输出都将会对应一个梯度输入到 `backward` 函数。所以，如果你的自定义操作在前向传播时生成了多个输出，你需要相应地在 `backward` 方法中处理这些输出的梯度。

以下是一个简单的例子：

    import torch
    
    class MyCustomFunction(torch.autograd.Function):
        @staticmethod
        def forward(ctx, input):
            # 这个函数处理输入并返回两个输出
            output1 = input + 1
            output2 = input * 2
            return output1, output2
        
        @staticmethod
        def backward(ctx, grad_output1, grad_output2):
            # 这里将接收到两个梯度，它们分别对应于 forward 的两个输出
            # 然后根据这些梯度计算输入的梯度
            grad_input = grad_output1 + (2 * grad_output2)
            return grad_input
    
    # 创建一个输入张量
    input_tensor = torch.tensor(1.0, requires_grad=True)
    
    # 应用自定义函数
    output1, output2 = MyCustomFunction.apply(input_tensor)
    
    # 假设一个简单的损失函数，我们只关心第二个输出
    loss = output2.sum()
    loss.backward()
    
    print(input_tensor.grad)  # => tensor(2.)，因为只有 output2 参与了 loss 的计算

在这个例子中，`MyCustomFunction.forward()` 返回了两个结果，而 `MyCustomFunction.backward()` 方法接收了两个梯度，这两个梯度分别与 `forward` 中的两个输出相对应。在实际应用中，你可能会遇到复杂的自定义操作，它需要根据多个输出的梯度来计算输入的梯度。

## Example

### Example 1

表达式：

$$
{\displaystyle \mathbf Y = \left( \mathbf A \mathbf {B} ^{-1} \right) ^{\top } + \operatorname {tr} \left( \mathbf A \right) \mathbf B}
$$

对$\mathbf A$求导：

$$
{\displaystyle \frac {\partial \mathbf Y}{\partial \mathbf {A} }= \mathbf {B} ^{-\top}} + I \otimes \mathbf B
$$

对$\mathbf B$的求导：

$$
{\displaystyle \frac {\partial \mathbf Y}{\partial \mathbf {B} } = - \mathbf {B}^{-\top} \mathbf A ^{\top} \mathbf {B}^{-\top} + \operatorname {tr} \left( \mathbf A \right) \mathbf I}
$$


代码：

    import torch
    
    class MatrixOpsFunction(torch.autograd.Function):
        @staticmethod
        def forward(ctx, A, B):
            """
            支持批量矩阵运算的正确实现
            A.shape = [batch, n, n]
            B.shape = [batch, n, n]
            """
            # 保存反向传播所需参数
            ctx.save_for_backward(A, B)
            
            # 批量矩阵求逆
            B_inv = torch.inverse(B)
            
            # 正确计算批量转置
            term1 = torch.matmul(A, B_inv).transpose(1, 2)  # [batch, n, n]
            
            # 批量迹计算 (关键修正)
            trace_A = torch.einsum('bii->b', A)  # 正确获取批量迹 [batch]
            trace_A = trace_A.view(-1, 1, 1)     # 调整为 [batch, 1, 1]
            
            term2 = trace_A * B  # 正确广播
            
            return term1 + term2
    
        @staticmethod
        def backward(ctx, grad_output):
            A, B = ctx.saved_tensors
            batch_size, n, _ = A.shape
            
            # 批量求逆
            B_inv = torch.inverse(B)
            
            # 计算梯度
            grad_A = torch.matmul(grad_output, B_inv.transpose(1, 2))
            grad_B = -torch.matmul(B_inv.transpose(1, 2), torch.matmul(A.transpose(1, 2), grad_output))
            grad_B = torch.matmul(grad_B, B_inv)
            
            # 迹相关的梯度修正
            trace_grad = torch.einsum('bii->b', grad_output).view(-1, 1, 1)
            grad_A += trace_grad * torch.eye(n, device=A.device).unsqueeze(0)
            grad_B += trace_grad * B
            
            return grad_A, grad_B
        
    
    # 测试数据
    batch_size = 2
    n = 3
    A = torch.randn(batch_size, n, n, dtype=torch.double, requires_grad=True)
    B = torch.randn(batch_size, n, n, dtype=torch.double, requires_grad=True)
    
    # 前向传播
    Y = MatrixOpsFunction.apply(A, B)
    
    # 反向传播
    loss = Y.norm()
    loss.backward()
    
    # 检查梯度形状
    print(f"A梯度形状: {A.grad.shape}")  # 应输出 torch.Size([2, 3, 3])
    print(f"B梯度形状: {B.grad.shape}")  # 应输出 torch.Size([2, 3, 3])
    
    # 数值梯度检验
    from torch.autograd import gradcheck
    
    # 创建专用测试张量（保持梯度追踪）
    test_A = torch.randn(2, 3, 3, dtype=torch.double, requires_grad=True)
    test_B = torch.randn(2, 3, 3, dtype=torch.double, requires_grad=True)
    
    # 执行梯度检验
    test = gradcheck(MatrixOpsFunction.apply, 
                    (test_A, test_B),  # 使用未分离的测试输入
                    eps=1e-6,
                    atol=1e-4,
                    check_sparse_nnz=True)  # 完整检验所有元素
    print(f"梯度检验结果: {test}")
    