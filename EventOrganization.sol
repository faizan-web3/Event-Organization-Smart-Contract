// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EventOrganization {
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint=>Event) public  events;
    mapping(address=>mapping(uint=>uint)) public  tickets;
    uint public nextId;


    function createEvent(string memory name, uint date, uint price, uint ticketCount) external  {
        require(date>block.timestamp,"You can organize evetn for future date");
        require(ticketCount > 0 ,"You can organize evetn only if you crate more then 0 tickets");
        
        events[nextId] = Event(msg.sender,name, date, price , ticketCount,ticketCount);
        nextId++;
    }

    function buyTicket(uint id, uint quantity) external  payable {
        require(events[id].date != 0,"Events Doesnot exites");
        require(events[id].date>block.timestamp,"Event has already occured");

        Event storage _event = events[id];

        require(msg.value==(_event.price*quantity),"Ethers is not enougth");
        require(_event.ticketRemain>= quantity,"Not enough tickets");
        _event.ticketRemain -=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    function transferTickets(uint id, uint quantity, address to) external   {
        require(events[id].date != 0,"Events Doesnot exites");
        require(events[id].date>block.timestamp,"Event has already occured");
        require(tickets[msg.sender][id]>=quantity, "You do not have enough tickets");

        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;

    }
}