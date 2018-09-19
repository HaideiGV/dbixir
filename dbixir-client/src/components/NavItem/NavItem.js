import React, { Link } from 'react';
import "./NavItem";

const navItem = (props) => (
    <div>
        <span className="NavItem" >
            <Link to={props.navItemUrl}>{props.navItemName}</Link>
        </span>
    </div>
);

export default navItem;