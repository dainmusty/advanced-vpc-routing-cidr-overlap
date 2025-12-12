# advanced-vpc-routing-cidr-overlap
Solving Overlapping CIDRs in AWS VPC Peering Using Longest-Prefix Routing
Last week, my team and I ran into one of those “classic but painful” AWS networking challenges — overlapping CIDRs with VPC peering.

We had three VPCs:

VPC-A: 10.16.0.0/16

VPC-B: 10.20.0.0/16

VPC-C: 10.20.0.0/16 (yes, same CIDR as VPC-B)

AWS doesn’t allow direct peering when two VPCs have overlapping CIDRs, so getting all three to communicate required some creative routing.
Below is how we approached it as a team.

1. Initial Setup — Basic Routing (Diagram 1)

To work around the overlap, we created two peering connections:

P-AB: VPC-A ↔ VPC-B

P-AC: VPC-A ↔ VPC-C

And routed traffic like this:

Traffic from VPC-B → Subnet A in VPC-A (via P-AB)

Traffic from VPC-C → Subnet B in VPC-A (via P-AC)

This allowed limited connectivity, but VPC-A still couldn’t reliably reach both VPC-B and VPC-C — because both use 10.20.0.0/16, and routes were conflicting.

2. Final Solution — Longest Prefix Match (Diagram 2)

We solved it using longest-prefix routing inside VPC-A.

Default route
10.20.0.0/16 → P-AB  (VPC-B)

Override for a specific host
10.20.0.20/32 → P-AC  (VPC-C)


Because AWS always prefers the most specific route:
/32 > /16
…traffic to that specific EC2 instance in VPC-C correctly routes through P-AC, while everything else in 10.20.0.0/16 goes to VPC-B.

And just like that — full connectivity, zero CIDR clashes, clean deterministic routing. ✔

💡 Key Takeaways

Overlapping CIDRs are normally a blocker in VPC peering

But with smart route design and longest-prefix matching, you can make multi-VPC communication work safely

Sometimes networking problems require both AWS knowledge and traditional routing logic

And yes — Terraform automation made reproducibility so much easier 

Shout-out to the team

This was a great debugging and problem-solving moment. Everyone contributed — from routing analysis to Terraform modules to testing connectivity edge cases.

🔧 Tools involved

AWS VPC • VPC Peering • EC2 • Route Tables • Longest Prefix Match
Terraform • Cloud Networking • Linux Networking (ping, traceroute)
