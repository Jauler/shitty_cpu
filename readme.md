# Shitty CPU

Some time ago, I participated in a [CTF](https://ctftime.org/event/994) and one [task](https://ctftime.org/task/11578) peeked my curiosity like no other.

This task was created in memory of John Conway for his research on [game of life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).
As it turns out, game of life is turing complete and CTF organizers created a small CPU which runs completely in game of life.

This CPU is made of so many cells, that just scrolling to see individual cells takes some time:

![scale](img/scrolling.gif)

This peeked my curiosity enough that I decided to design my own simple CPU in order to better understand how CPU's work under the hood.

## Idea

For my purposes I need something as simple as it gets.
So do not expect anything fancy like pipelines, interrupts, fancy maths or whatever...

The need for simplicity basically dictated [von Neumann](https://en.wikipedia.org/wiki/Von_Neumann_architecture) architecture.
Also in order to be able to do any kind of maths the minimum amount of registers required was two - and thus, A and B registers were born.
The "maths" I am talking about here is just a simple addition of those two registers.
Obviously because this is two's complement addition, just adding negated number will give us subtraction for free.
For simplicitly I decided to ditch logic operations.

To be turing complete - I will also need some conditional branching, so basically jumps to some address only if the result of addition is zero.

Because I will try to write at least one real program for this CPU (aka blink some LEDs), it would be quite nice to be able to address memory directly "inside" instructions.
In the end this "requirement" ended up somewhat complicating CPU design, but, as a result, the instruction set became much more flexible.

Oh and of course - this is an 8 bit CPU.
Why whould you choose anything else in this scenario?

At first I thought that it would be nice to find some logic simulators and build the whole CPU out of logic elements by manually connecting them.
But after some reading, it felt like [HDLs](https://en.wikipedia.org/wiki/Hardware_description_language) are a natural fit for this.
Even though those operate at a bit "higher-level".

I chose VHDL completely arbitrary, no preference for this over the other languages.

## Components

It turns out, that (simple) CPUs do not require that many components after all.
In this CPU there basically is:
* A few Multiplexer
* Some registers
* ALU (although it does not do any logical operations, so this is more of AU than ALU :D)
* Controller

### Multiplexer

Well this is a simple component which "connects" single output to some number of inputs.
Input selection is controlled by the binary value of selection signals.

![multiplexer](img/mux.png)

In this example there are four inputs, one output and consequently - two selection signals.

This is a truth table ("sort of"):

|sel2|sel1|  output  |
|----|----|----------|
| L  | L  |out == in1|
| L  | H  |out == in2|
| H  | L  |out == in3|
| H  | H  |out == in4|

This is an example 1 bit multiplexer out of pure logic elements:

![multiplexer_logic](img/mux.gif)

If we would like to build a multiplexer with wider inputs than one bit - we can simply copy this circuit multiple times.
All respective selection pins from separate 1 bit muxes should be connected together and inputs to separate 1 bit muxes represent separate bits of input.

For our 8 bit CPU's we will be using a [multiplexer](mux.vhdl) with 8 seperate inputs (and 4 selector signals each) each of which is 8 bits wide.

Note that VHDL most likely will synthesize multiplexer into something more complex, this is mostly for the idea.

### Register

Register is basically a small memory built from logic components (think expensive memory :D).

This CPU will be using so called "synchronized" registers, meaning that it will set its value only on rising clock edge.
So our register should have:
* data input
* clock input
* write enable input
* output

So basically I would like a "memory" which remembers input value when clock is on the rising edge and write enable input is high.
And output should always represent the "remembered" value.

This is how we can achieve this for single bit:

![register](img/register.gif)

This is called D-flip flop.

Again wider register can be achieved by connecting "control" (clock, write enable) inputs together for multiple flip flops and data inputs for separate bits connecting to separate flip flops.


### ALU

TODO


### Controller

TODO

