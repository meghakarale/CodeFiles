# ============================================================
# 18. Install JupyterLab
# ============================================================

echo "Installing JupyterLab..."

python -m pip install --no-cache-dir jupyterlab

echo "JupyterLab version:"
jupyter-lab --version


# ============================================================
# 19. Install OCI CLI
# ============================================================

echo "============================================================"
echo "Installing OCI CLI"
echo "============================================================"


# Remove incomplete OCI CLI installation if present

if [ -d "$HOME/lib/oracle-cli" ]; then

    echo "Removing previous OCI CLI installation..."

    rm -rf "$HOME/lib/oracle-cli"

fi

rm -f "$HOME/bin/oci"
rm -rf "$HOME/bin/oci-cli-scripts"


cd "$HOME"

curl -fsSL \
https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh \
-o install.sh

chmod +x install.sh

./install.sh --accept-all-defaults


# ------------------------------------------------------------
# Configure OCI CLI PATH
# ------------------------------------------------------------

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

grep -qxF 'export PATH="$HOME/bin:$HOME/.local/bin:$PATH"' "$HOME/.bashrc" || \
echo 'export PATH="$HOME/bin:$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"


# ============================================================
# 20. Verify OCI CLI
# ============================================================

echo "Verifying OCI CLI installation..."

if ! command -v oci >/dev/null 2>&1; then

    echo "ERROR: OCI CLI executable not found."

    exit 1

fi

oci --version

echo "OCI CLI installed successfully."


# ============================================================
# 21. Download Lab Files
# ============================================================

echo "============================================================"
echo "Downloading lab files"
echo "============================================================"

REPO_URL="https://github.com/ou-developers/ou-ai-foundations.git"

FINAL_DIR="$HOME/labs"

cd "$FINAL_DIR"


# Remove incomplete git metadata if present
rm -rf .git


git init

git remote add origin "$REPO_URL"

git config core.sparseCheckout true

mkdir -p .git/info

echo "labs/*" > .git/info/sparse-checkout


echo "Downloading labs directory from repository..."

git pull origin main


# ------------------------------------------------------------
# Move repository labs content into ~/labs
# ------------------------------------------------------------

if [ -d "$FINAL_DIR/labs" ]; then

    cp -a "$FINAL_DIR/labs/." "$FINAL_DIR/"

    rm -rf "$FINAL_DIR/labs"

fi


# Remove temporary git metadata
rm -rf "$FINAL_DIR/.git"

echo "Lab files downloaded successfully."




# ============================================================
# 22. Final Verification
# ============================================================

echo "============================================================"
echo "Final Environment Verification"
echo "============================================================"

cd "$HOME/labs"


echo "Python:"
python --version

echo ""

echo "Python executable:"
which python

echo ""

echo "Pyenv selection:"
pyenv version

echo ""

echo "Pip:"
python -m pip --version

echo ""

echo "JupyterLab:"
jupyter-lab --version

echo ""

echo "OCI CLI:"
oci --version

echo ""

echo "Lab directory:"
pwd

echo ""

echo "Initialization for opc user completed successfully."


EOF_OPC

# ============================================================
# Verify Oracle Container
# ============================================================
echo "============================================================"
echo "Oracle Container Verification"
echo "============================================================"

sudo podman ps --filter name=26ai

echo ""

# ============================================================
# 23. Create Success Marker
# ============================================================

touch "$MARKER_FILE"

chown opc:opc "$MARKER_FILE"


echo "============================================================"
echo "GENAI LAB INITIALIZATION COMPLETED SUCCESSFULLY"
echo "============================================================"

echo ""
echo "Python 3.11.9 configured."
echo "Oracle Database 26ai container created."
echo "Python 3.11.9 set as pyenv global default."
echo "Python 3.11.9 configured for ~/labs."
echo "JupyterLab installed."
echo "GenAI libraries installed."
echo "SentenceTransformer model downloaded."
echo "OCI CLI installed."
echo "Lab files downloaded."
echo ""

exit 0
