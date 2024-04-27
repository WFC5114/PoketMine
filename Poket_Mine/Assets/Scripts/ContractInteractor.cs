using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Thirdweb;
using System.Numerics;
using System; 

public class ContractInteractor : MonoBehaviour
{
    private string contractAddress = "0x40C34E6a2f398F1fd0bC386c0F7F57551587fA61";
    private Contract contract;
    private ThirdwebSDK sdk; // Declare the sdk variable here if it's used in multiple methods

void Start()
{
    string rpcUrl = "https://sepolia.infura.io/v3/97add8653eb04646a5d95f8034ccd8f1";
    BigInteger chainId = new BigInteger(11155111); // Correct chain ID for Sepolia

    ThirdwebSDK.Options options = new ThirdwebSDK.Options();
    // Ensure options are properly configured if necessary

    try
    {
        sdk = new ThirdwebSDK(rpcUrl, chainId, options);
        contract = sdk.GetContract(contractAddress);
        Debug.Log("Thirdweb SDK initialized");
    }
    catch (Exception e)
    {
        Debug.LogError($"Failed to initialize Thirdweb SDK: {e.Message}");
    }
}


    public async void GetCreatureAttributes(BigInteger tokenId)
    {
        if (contract == null)
        {
            Debug.LogError("Contract is not initialized.");
            return;
        }

        try
        {
            var result = await contract.Read<CreatureAttributes>("creatureAttributes", tokenId);
            Debug.Log($"Level: {result.Level}, Experience: {result.Experience}, CryptoBound: {result.CryptoBound}");
        }
        catch (Exception e)
        {
            Debug.LogError("Failed to fetch creature attributes: " + e.Message);
        }
    }

    [System.Serializable]
    public class CreatureAttributes
    {
        public int Level;
        public int Experience;
        public BigInteger CryptoBound;
    }
}
