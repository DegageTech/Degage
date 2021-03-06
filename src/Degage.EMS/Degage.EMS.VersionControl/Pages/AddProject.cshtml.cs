using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;
using Degage.Extension;
namespace Degage.EMS.VersionControl.Pages
{
    [IgnoreAntiforgeryToken(Order = 1001)]
    public class AddProjectModel : PageModel
    {
        protected ILogger<AddProjectModel> Logger { get; set; }
        protected IProjectInfoDataAccessor DataAccessor { get; set; }
        protected IdentifyFactory IdentifyFactory { get; set; }
        public String ReturnUrl { get; private set; }
        public AddProjectModel(ILogger<AddProjectModel> logger, IProjectInfoDataAccessor accessor, IdentifyFactory identifyFactory)
        {
            this.Logger = logger;
            this.DataAccessor = accessor;
            this.IdentifyFactory = identifyFactory;
        }

        public async Task<IActionResult> OnGetAsync(String returnUrl)
        {
            this.ReturnUrl = returnUrl;
            return await Task.FromResult(this.Page());
        }

        public async Task<JsonResult> OnPostAddProjectInfoAsync([FromForm]ProjectInfo info)
        {
            //参数检查  
            if (info.Title.IsNullOrEmpty())
            {
                return this.CreateJsonResult(false, ResponseMessages.InvaildParameter + " 项目标题不能为空！");
            }
            info.CreationTime = TimeAssistor.Now;
            info.LastAccessTime = TimeAssistor.Now;
            info.Id = this.IdentifyFactory.CreateId();
            info.IsRemoved = false;
            var success = await Task.FromResult(this.DataAccessor.AddProjectInfo(info));
            if (!success)
            {
                return this.CreateJsonResult(success,ResponseMessages.DataOperateFailed);
            }
            else
            {
                return this.CreateJsonResult(success, info);
            }
        }
        
    }

}
