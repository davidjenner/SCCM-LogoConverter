Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$MainForm                        = New-Object system.Windows.Forms.Form
$MainForm.ClientSize             = New-Object System.Drawing.Point(500, 350) # Updated width and height
$MainForm.text                   = "Convert Logos to PNGs"
$MainForm.TopMost                = $false
$MainForm.icon                   = "C:\users\davidjenner\Documents\Scripts\Image Converter\logoconverter.ico"
$MainForm.CancelButton           = $null # Setting CancelButton to null to remove default behavior

$DescriptionLabel                = New-Object system.Windows.Forms.Label
$DescriptionLabel.Text           = "This tool allows you to upload all image file formats logos to 256x256 and 512x512 pixels PNGs so you can upload them into SCCM for packaging."
$DescriptionLabel.AutoSize       = $false
$DescriptionLabel.ForeColor      = [System.Drawing.Color]::Black
$DescriptionLabel.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$DescriptionLabel.Location       = New-Object System.Drawing.Point(23,26) # Adjusted location (+30)
$DescriptionLabel.Size           = New-Object System.Drawing.Size(350, 50) # Adjusted size to wrap text

$LinksLabel                      = New-Object system.Windows.Forms.Label
$LinksLabel.Text                 = "For logos, visit: "
$LinksLabel.AutoSize             = $true
$LinksLabel.ForeColor            = [System.Drawing.Color]::Black
$LinksLabel.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$LinksLabel.Location             = New-Object System.Drawing.Point(23,82) # Adjusted location (+50)
$LinksLabel.Anchor               = "Top,Left"


$Link1000Logos                   = New-Object System.Windows.Forms.LinkLabel
$Link1000Logos.Text              = "1000logos"
$Link1000Logos.AutoSize          = $true
$Link1000Logos.LinkColor         = [System.Drawing.Color]::Blue
$Link1000Logos.Location          = New-Object System.Drawing.Point(23,112) # Adjusted location (+20)
$Link1000Logos.Add_Click({
    Start-Process "https://www.1000logos.net/"
})


$LinkSeekLogo                    = New-Object System.Windows.Forms.LinkLabel
$LinkSeekLogo.Text               = "seeklogo"
$LinkSeekLogo.AutoSize           = $true
$LinkSeekLogo.LinkColor          = [System.Drawing.Color]::Blue
$LinkSeekLogo.Location           = New-Object System.Drawing.Point(100,112) # Adjusted location (to the right)
$LinkSeekLogo.Add_Click({
    Start-Process "https://seeklogo.com/"
})

$UploadImages                    = New-Object system.Windows.Forms.Button
$UploadImages.text               = "Upload Image"
$UploadImages.width              = 336
$UploadImages.height             = 93
$UploadImages.location           = New-Object System.Drawing.Point(23,152) # Adjusted location (+50)
$UploadImages.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$MainForm.controls.Add($UploadImages)

$SuccessLabel                    = New-Object system.Windows.Forms.Label
$SuccessLabel.Text               = "Success!! Your PNGs have downloaded ready for packaging!"
$SuccessLabel.AutoSize           = $true
$SuccessLabel.ForeColor          = [System.Drawing.Color]::Green
$SuccessLabel.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',20) # Updated font size
$SuccessLabel.Visible            = $false
$SuccessLabel.Location           = New-Object System.Drawing.Point(23,262) # Adjusted location (+100)
$SuccessLabel.MaximumSize        = New-Object System.Drawing.Size(450, 0) # Wrap text after 500 pixels width

# Increase height of LinksLabel
$LinksLabel.Size                 = New-Object System.Drawing.Size(550, 50) # Adjusted size to accommodate links

$MainForm.controls.AddRange(@($DescriptionLabel, $UploadImages, $LinksLabel, $Link1000Logos, $LinkSeekLogo, $SuccessLabel))

# Logic for handling image upload
$UploadImages.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Image Files (*.jpg;*.jpeg;*.png;*.bmp;*.gif;*.tiff;*.svg;*.webp)|*.jpg;*.jpeg;*.png;*.bmp;*.gif;*.tiff;*.svg;*.webp"
    $result = $openFileDialog.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedFile = $openFileDialog.FileName
        # Your logic for handling the selected image goes here
        # Write-Host "Selected file: $selectedFile"
        
        # Load the image
        $originalImage = [System.Drawing.Image]::FromFile($selectedFile)
        
        # Calculate dimensions for resizing (512x512)
        $scaleFactor512 = [Math]::Min(512.0 / $originalImage.Width, 512.0 / $originalImage.Height)
        $newWidth512 = [Math]::Round($originalImage.Width * $scaleFactor512)
        $newHeight512 = [Math]::Round($originalImage.Height * $scaleFactor512)
        
        # Create a resized image (512x512)
        $resized512Image = New-Object System.Drawing.Bitmap 512, 512
        $graphic512 = [System.Drawing.Graphics]::FromImage($resized512Image)
        $graphic512.Clear([System.Drawing.Color]::White) # Fill transparent background with white
        $graphic512.DrawImage($originalImage, 0, 0, $newWidth512, $newHeight512)
        $graphic512.Dispose()
        
        # Save the resized image (512x512)
        $savePath512 = [System.IO.Path]::ChangeExtension($selectedFile, ".512x512.png")
        $resized512Image.Save($savePath512, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Calculate dimensions for resizing (256x256)
        $scaleFactor256 = [Math]::Min(256.0 / $originalImage.Width, 256.0 / $originalImage.Height)
        $newWidth256 = [Math]::Round($originalImage.Width * $scaleFactor256)
        $newHeight256 = [Math]::Round($originalImage.Height * $scaleFactor256)
        
        # Create a resized image (256x256)
        $resized256Image = New-Object System.Drawing.Bitmap 256, 256
        $graphic256 = [System.Drawing.Graphics]::FromImage($resized256Image)
        $graphic256.Clear([System.Drawing.Color]::White) # Fill transparent background with white
        $graphic256.DrawImage($originalImage, 0, 0, $newWidth256, $newHeight256)
        $graphic256.Dispose()
        
        # Save the resized image (256x256)
        $savePath256 = [System.IO.Path]::ChangeExtension($selectedFile, ".256x256.png")
        $resized256Image.Save($savePath256, [System.Drawing.Imaging.ImageFormat]::Png)
       
        # Dispose the images
        $originalImage.Dispose()
        $resized512Image.Dispose()
        $resized256Image.Dispose()
        
        # Show success message
        $SuccessLabel.Visible = $true
    }
})

# Show the form
$MainForm.ShowDialog()
