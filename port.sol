// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
//0xDb8766f20d3F1bEa763b06faFfa9BD90B32FF5A8 - contract hash
contract Portfolio{
    struct Project{
        uint id;
        string name;
        string description;
        string image;
        string githublink;
    }

    struct Eduction {
        uint id;
        string data;
        string degree;
        string knowlgeAcquired;
        string instutionName;
    }
    Project[3] public Projects;
    Eduction[3] public educationDetails;
    string public imagelink = "";
    string public decription="";
    string public resumeLink="";
    uint projectCount;
    uint educationcount;
    address public manager; 

   constructor(){
       manager=msg.sender;

   }
   modifier onlyManger(){
       require(manager==msg.sender,"only msg can change");
       _;
   }
 // this function perform inserting data in blockchain
 // i use calldata becoz it cansume less gass campare to memory 
 // calldata use becoz with arrgument i am not perform any change that  
function insertProject(string calldata _name,string calldata _description,string calldata _image,string calldata _githubLink)external onlyManger {
    require(projectCount<3,"only 3 project");
    Projects[projectCount] = Project(projectCount,_name,_description,_image,_githubLink);
    projectCount++;

}
function ChangeProject(string calldata _name,string calldata _description,string calldata _image,string calldata _githubLink,uint projectCount_)external onlyManger{
     require(projectCount >=0 && projectCount<3,"only 3 project");
    Projects[projectCount] = Project(projectCount,_name,_description,_image,_githubLink);
    projectCount++;
}

function allProjects() external  onlyManger view returns(Project[3] memory){
    return Projects;

} 

// for Eduction insert function
  function InsertEduction(string calldata _data,string calldata _degree,string calldata _knowlgeAcquired, string calldata _instutionName)external onlyManger{
      require(educationcount<3,"only 3");
      educationDetails[educationcount] = Eduction(educationcount,_data,_degree,_knowlgeAcquired,_instutionName);
      educationcount++;
      
  }
  function ChangeEduction(string calldata _data,string calldata _degree,string calldata _knowlgeAcquired, string calldata _instutionName,uint _educationcount )external onlyManger{
    require(educationcount >=0 && educationcount<3,"only 3 project");
    educationDetails[educationcount] = Eduction(_educationcount,_data,_degree,_knowlgeAcquired,_instutionName);
    educationcount++;

    
  }
  function allEduction() external onlyManger  view returns (Eduction[3]memory){
      return educationDetails;

  }
  function ChangeDescription(string calldata _decription) external onlyManger{
      decription = _decription;

  }
  function Changeimagelink(string calldata _imagelink) external onlyManger{
      imagelink = _imagelink;

  }
   function ChangeresumeLink(string calldata _resumeLink) external onlyManger{
      imagelink = _resumeLink;

  }

  function donate() public payable {
      payable(manager).transfer(msg.value);
  }
  
}