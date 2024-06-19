# autograd

- [autograd](#autograd)
  - [Reference](#reference)
  - [Reverse accumulation exercise](#reverse-accumulation-exercise)
  - [`torch.autograd.Function` exercise](#torchautogradfunction-exercise)
  - [Q\&A](#qa)
    - [什么情况下继承了torch.autograd.Function类的forward函数会有多个返回值](#什么情况下继承了torchautogradfunction类的forward函数会有多个返回值)

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

